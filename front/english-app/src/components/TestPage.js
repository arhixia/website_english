import React, { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import "./styles.css";

const TestPage = () => {
    const { id } = useParams();
    const [test, setTest] = useState(null);
    const [answers, setAnswers] = useState({});
    const [result, setResult] = useState(null);
    const [incorrectQuestions, setIncorrectQuestions] = useState([]);

    useEffect(() => {
        fetch(`http://localhost:8000/tests/${id}`)
            .then((res) => res.json())
            .then((data) => {
                setTest(data);
                setAnswers(
                    data.quizzes.reduce((acc, quiz) => {
                        acc[quiz.id] = "";
                        return acc;
                    }, {})
                );
            })
            .catch((error) => console.error("Ошибка загрузки теста:", error));
    }, [id]);

    const handleAnswerChange = (quizId, answer) => {
        setAnswers((prev) => ({ ...prev, [quizId]: answer }));
    };

    const handleSubmit = () => {
        const userId = localStorage.getItem("user_id");

        if (!userId) {
            alert("Ошибка: пользователь не авторизован.");
            return;
        }

        fetch(`http://localhost:8000/tests/${id}/submit`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
                user_id: parseInt(userId),
                answers: Object.entries(answers).map(([quizId, selectedAnswer]) => ({
                    quiz_id: parseInt(quizId),
                    selected_answer: selectedAnswer,
                })),
            }),
        })
            .then((res) => res.json())
            .then((data) => {
                setResult(data);
                setIncorrectQuestions([]);
                fetch(`http://localhost:8000/user/${userId}/progress`)
                    .then((res) => res.json())
                    .then((progressData) => {
    const userTestProgress = progressData.find(
        (t) => t.test_id === parseInt(id)  // сравнение с текущим тестом
    );
    if (userTestProgress) {
        setIncorrectQuestions(userTestProgress.incorrect_answers);
    } else {
        setIncorrectQuestions([]); // Если нет ошибок — пустой список
    }
})
                    .catch((error) =>
                        console.error("Ошибка загрузки прогресса:", error)
                    );
            })
            .catch((error) => console.error("Ошибка отправки теста:", error));
    };

    if (!test) return <p>Download...</p>;

    if (result)
        return (
            <div className="result-container">
                <p className="result">Your result: {result.score}/10</p>
                {incorrectQuestions.length > 0 && (
                    <>
                        <h3>Mistakes:</h3>
                        <ul className="incorrect-list">
                            {incorrectQuestions.map((q) => (
                                <li key={q.quiz_id}>
                                    <strong>{q.question_title}</strong>: <br />
                                    Your answer:{" "}
                                    <span className="wrong-answer">{q.user_answer}</span> <br />
                                    Correct answer:{" "}
                                    <span className="correct-answer">
                                        {q.correct_answer}
                                    </span>
                                </li>
                            ))}
                        </ul>
                    </>
                )}
            </div>
        );

    return (
        <div className="test-container">
            <h2 className="test-title">{test.title}</h2>
            <p className="test-description">{test.description}</p>
            {test.quizzes.map((quiz) => (
                <div key={quiz.id} className="question-block">
                    <p className="question-title">{quiz.question_title}</p>
                    <p className="question-topic"><em>{quiz.topic}</em></p>
                    <div className="question">
                        {quiz.question.replace(/\\n/g, '\n').split('\n').map((line, idx) => (
  <p key={idx} className="question-line">{line}</p>
))}

                    </div>


                    {quiz.options.map((option, index) => (
                        <label key={index} className="answer-label">
                            <input
                                type="radio"
                                name={`quiz-${quiz.id}`}
                                value={String.fromCharCode(97 + index)}
                                checked={answers[quiz.id] === String.fromCharCode(97 + index)}
                                onChange={() =>
                                    handleAnswerChange(quiz.id, String.fromCharCode(97 + index))
                                }
                            />
                            {option}
                        </label>
                    ))}
                </div>
            ))}
            <button className="submit-button" onClick={handleSubmit}>
                Finish test
            </button>
        </div>
    );
};

export default TestPage;
