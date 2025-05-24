from sqlalchemy import Column, Integer, String, ForeignKey, Text, Boolean, ARRAY
from sqlalchemy.orm import relationship, declarative_base

Base = declarative_base()


class User(Base):
    __tablename__ = 'users'

    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, unique=True, index=True, nullable=False)
    hashed_password = Column(String, nullable=False)

    progress = relationship("UserProgress", back_populates="user")
    test_results = relationship("TestResult", back_populates="user")


class Test(Base):
    __tablename__ = 'tests'

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, nullable=False)  # Название теста
    description = Column(Text, nullable=True)  # Описание теста

    quizzes = relationship("Quiz", back_populates="test")


class Quiz(Base):
    __tablename__ = 'quizzes'

    id = Column(Integer, primary_key=True, index=True)
    test_id = Column(Integer, ForeignKey('tests.id'), nullable=False)  # Связь с тестом
    question_title = Column(String, nullable=False)  # Название вопроса
    topic = Column(String, nullable=False)  # Тема вопроса
    question = Column(Text, nullable=False)  # Сам вопрос
    options = Column(ARRAY(String), nullable=False)  # Варианты ответа (если есть)
    answer = Column(String, nullable=False)  # Правильный ответ

    test = relationship("Test", back_populates="quizzes")
    results = relationship("QuizResult", back_populates="quiz")


class QuizResult(Base):
    __tablename__ = 'quiz_results'

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey('users.id'), nullable=False)
    quiz_id = Column(Integer, ForeignKey('quizzes.id'), nullable=False)
    user_answer = Column(String, nullable=False)
    is_correct = Column(Boolean, nullable=False)

    quiz = relationship("Quiz", back_populates="results")


class UserProgress(Base):
    __tablename__ = 'user_progress'

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey('users.id'), nullable=False)
    test_id = Column(Integer, ForeignKey('tests.id'), nullable=False)
    incorrect_questions = Column(ARRAY(Integer), nullable=True)  # ID вопросов, где были ошибки

    user = relationship("User", back_populates="progress")
    test = relationship("Test")


class TestResult(Base):
    __tablename__ = 'test_results'

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey('users.id'), nullable=False)
    test_id = Column(Integer, ForeignKey('tests.id'), nullable=False)
    score = Column(Integer, nullable=False)  # Количество набранных баллов (0-10)
    incorrect_topics = Column(ARRAY(String), nullable=True)  # Темы, в которых были ошибки

    user = relationship("User", back_populates="test_results")
    test = relationship("Test")


