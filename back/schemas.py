from pydantic import BaseModel
from typing import List, Optional


class UserCreate(BaseModel):
    username: str
    password: str

    class Config:
        orm_mode = True

class UserResponse(BaseModel):
    username: str  # Без password!

    class Config:
        orm_mode = True

class Token(BaseModel):
    access_token: str
    token_type: str
    user_id: int  # добавляем это поле


class QuizResponse(BaseModel):
    id: int
    question_title: str
    topic: str
    question: str
    options: List[str]

    class Config:
        orm_mode = True


class TestResponse(BaseModel):
    id: int
    title: str
    description: str
    quizzes: List[QuizResponse]

    class Config:
        orm_mode = True

class AnswerRequest(BaseModel):
    quiz_id: int  # ID вопроса
    selected_answer: str  # Ответ пользователя (a, b, c, d)


class TestSubmitRequest(BaseModel):
    user_id: int  # ID пользователя
    answers: List[AnswerRequest]

class IncorrectQuizResponse(BaseModel):
    quiz_id: int
    question_title: str
    question: str
    user_answer: str
    correct_answer: str

    class Config:
        orm_mode = True


class UserProgressResponse(BaseModel):
    test_id: int
    test_title: str
    incorrect_answers: List[IncorrectQuizResponse]
