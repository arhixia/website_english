from typing import List, Optional
from fastapi import FastAPI, status, Depends, HTTPException, BackgroundTasks
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session, joinedload
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from jose import JWTError, jwt
from passlib.context import CryptContext
from models import User,Test,TestResult,QuizResult,Quiz
from database import SessionLocal, engine
from datetime import datetime, timedelta
from config import SECRET_KEY
import time
import redis
from schemas import UserCreate, UserResponse, Token, TestSubmitRequest, UserProgressResponse, TestResponse, \
    IncorrectQuizResponse
import logging


logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


redis_client = redis.Redis(host='redis_server', port=6379, db=0, decode_responses=True)

app = FastAPI()

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

origins = [
    "http://localhost:3000",  # Adjust the port if your frontend runs on a different one
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=['*'],  # Allows all origins from the list
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30
token_blacklist = set()





# Функция хеширования пароля
def get_password_hash(password: str) -> str:
    return pwd_context.hash(password)


# Функция проверки пароля
def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)


# Получение пользователя по имени
def get_user_by_username(db: Session, username: str) -> Optional[User]:
    return db.query(User).filter(User.username == username).first()


# Создание пользователя
def create_user(db: Session, user: UserCreate):
    hashed_password = get_password_hash(user.password)
    db_user = User(username=user.username, hashed_password=hashed_password)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user


# Регистрация пользователя
@app.post("/register", response_model=UserResponse)
def register_user(user: UserCreate, db: Session = Depends(get_db)):
    db_user = get_user_by_username(db, user.username)
    if db_user:
        raise HTTPException(status_code=400, detail="Username already registered")
    return create_user(db, user)


# Аутентификация пользователя
def authenticate_user(db: Session, username: str, password: str) -> Optional[User]:
    user = get_user_by_username(db, username)
    if not user or not verify_password(password, user.hashed_password):
        return None
    return user


# Функция создания JWT токена
def create_access_token(data: dict, expires_delta: Optional[timedelta] = None) -> str:
    to_encode = data.copy()
    expire = datetime.utcnow() + (expires_delta or timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES))
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)


# Эндпоинт для входа в систему
@app.post("/token", response_model=Token)
def login_for_access_token(
    form_data: UserCreate, db: Session = Depends(get_db)
):
    user = authenticate_user(db, form_data.username, form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token = create_access_token(data={"sub": user.username})
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user_id": user.id  # <-- добавляем user_id
    }



# Функция проверки токена
def verify_token(token: str) -> str:
    if redis_client.sismember("token_blacklist", token):
        logger.info(f"Blocked token detected in Redis: {token}")
        raise HTTPException(status_code=403, detail="Token has been revoked")

    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        if not username:
            raise HTTPException(status_code=403, detail="Invalid token")
        logger.info(f"Token verified successfully for user: {username}")
        return username
    except JWTError as e:
        logger.warning(f"JWT decode failed: {e}")
        raise HTTPException(status_code=403, detail="Invalid or expired token")




# Эндпоинт для проверки токена
@app.get("/verify-token/{token}")
async def verify_user_token(token: str):
    username = verify_token(token)
    return {"username": username}

@app.post("/logout")
def logout(token: str = Depends(oauth2_scheme)):
    redis_client.sadd("token_blacklist", token)
    logger.info(f"Token added to Redis blacklist: {token}")
    return {"message": "Successfully logged out"}



@app.get("/tests/{test_id}", response_model=TestResponse)
def get_test(test_id: int, db: Session = Depends(get_db)):
    test = (
        db.query(Test)
        .options(joinedload(Test.quizzes))
        .filter(Test.id == test_id)
        .first()
    )

    if not test:
        raise HTTPException(status_code=404, detail="Test not found")

    return test

@app.post("/tests/{test_id}/submit")
def submit_test(test_id: int, submission: TestSubmitRequest, db: Session = Depends(get_db)):
    test = db.query(Test).filter(Test.id == test_id).first()
    if not test:
        raise HTTPException(status_code=404, detail="Test not found")

    user = db.query(User).filter(User.id == submission.user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    score = 0  # Счет пользователя
    incorrect_topics = []  # Темы, в которых были ошибки

    for answer in submission.answers:
        quiz = db.query(Quiz).filter(Quiz.id == answer.quiz_id).first()
        if not quiz:
            continue

        is_correct = (
                answer.selected_answer.strip().lower() == quiz.answer.strip().lower()
        )

        # Проверяем, есть ли уже результат для этого пользователя и вопроса
        quiz_result = db.query(QuizResult).filter(
            QuizResult.user_id == user.id,
            QuizResult.quiz_id == quiz.id
        ).first()

        if quiz_result:
            # Обновляем существующий результат
            quiz_result.user_answer = answer.selected_answer
            quiz_result.is_correct = is_correct
        else:
            # Если результата нет, создаем новый
            quiz_result = QuizResult(
                user_id=user.id,
                quiz_id=quiz.id,
                user_answer=answer.selected_answer,
                is_correct=is_correct
            )
            db.add(quiz_result)

        if is_correct:
            score += 1
        else:
            incorrect_topics.append(quiz.topic)

    # Сохранение общего результата теста
    # Проверяем, есть ли уже результат теста
    existing_test_result = db.query(TestResult).filter(
        TestResult.user_id == user.id,
        TestResult.test_id == test_id
    ).first()

    if existing_test_result:
        # Обновляем существующий результат
        existing_test_result.score = score
        existing_test_result.incorrect_topics = list(set(incorrect_topics))
    else:
        # Если результата нет, создаем новый
        test_result = TestResult(
            user_id=user.id,
            test_id=test_id,
            score=score,
            incorrect_topics=list(set(incorrect_topics))  # Убираем дубликаты
        )
        db.add(test_result)

    db.commit()

    return {"message": "Test submitted successfully", "score": score, "incorrect_topics": incorrect_topics}

@app.get("/user/{user_id}/progress", response_model=List[UserProgressResponse])
def get_user_progress(user_id: str, db: Session = Depends(get_db)):
    if user_id == "undefined" or not user_id.isdigit():
        raise HTTPException(status_code=400, detail="Invalid user ID")

    user_id = int(user_id)  # Преобразуем в целое число
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    progress_data = []

    test_results = db.query(TestResult).filter(TestResult.user_id == user_id).all()

    for test_result in test_results:
        incorrect_answers = (
            db.query(QuizResult)
            .join(Quiz)
            .filter(
                QuizResult.user_id == user_id,
                QuizResult.is_correct == False,
                Quiz.test_id == test_result.test_id  # Фильтрация по текущему тесту
            )
            .all()
        )

        if not incorrect_answers:
            continue

        incorrect_quizzes = []
        for quiz_result in incorrect_answers:
            quiz = db.query(Quiz).filter(Quiz.id == quiz_result.quiz_id).first()
            if quiz:
                incorrect_quizzes.append(
                    IncorrectQuizResponse(
                        quiz_id=quiz.id,
                        question_title=quiz.question_title,
                        question=quiz.question,
                        user_answer=quiz_result.user_answer,
                        correct_answer=quiz.answer,
                    )
                )

        progress_data.append(
            UserProgressResponse(
                test_id=test_result.test_id,
                test_title=db.query(Test).filter(Test.id == test_result.test_id).first().title,
                incorrect_answers=incorrect_quizzes,
            )
        )

    return progress_data



@app.delete("/user/{user_id}/progress")
def clear_user_progress(user_id: int, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    db.query(QuizResult).filter(QuizResult.user_id == user_id).delete()
    db.query(TestResult).filter(TestResult.user_id == user_id).delete()
    db.commit()

    return {"message": "User progress cleared successfully"}
