import React, { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import "./styles.css";
import { toast } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";

const UserProgress = () => {
    const { id: storedUserId } = useParams();

    const [progress, setProgress] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [showModal, setShowModal] = useState(false);

    useEffect(() => {
        if (!storedUserId) {
            setError("ID пользователя не найден");
            setLoading(false);
            return;
        }

        fetch(`http://localhost:8000/user/${storedUserId}/progress`)
            .then((res) => {
                if (!res.ok) throw new Error("Ошибка загрузки данных");
                return res.json();
            })
            .then((data) => {
                setProgress(data);
                setLoading(false);
            })
            .catch((err) => {
                setError(err.message);
                setLoading(false);
            });
    }, [storedUserId]);

    const handleClearClick = () => {
        setShowModal(true);
    };

    const confirmClearProgress = () => {
        if (!storedUserId) return;

        fetch(`http://localhost:8000/user/${storedUserId}/progress`, {
            method: "DELETE",
        })
            .then((res) => {
                if (!res.ok) throw new Error("Error clearing progress");
                return res.json();
            })
            .then(() => {
                setProgress([]);
                toast.success("Progress cleared successfully!", { position: "top-center" });
            })
            .catch((err) => {
                setError(err.message);
            })
            .finally(() => {
                setShowModal(false);
            });
    };

    if (loading) return <p>Загрузка...</p>;
    if (error) return <p className="error-message">Ошибка: {error}</p>;

    return (
        <div className="progress-container">
            <h2>User mistakes</h2>

            <button className="clear-button" onClick={handleClearClick}>
                Clear Progress
            </button>

            {progress.length === 0 ? (
                <p>You made no mistakes in the tests!  🎉</p>
            ) : (
                <div className="tests-list">
                    {progress.map((test, index) => (
                        <div key={`${test.test_id}-${index}`} className="test-block">
                            <h3>{test.test_title}</h3>
                            <p>Ошибок: {test.incorrect_answers.length}</p>
                            <ul className="incorrect-questions">
                                {test.incorrect_answers.map((quiz, i) => (
                                    <li key={`${quiz.quiz_id}-${i}`}>
                                        <strong>{quiz.question_title}</strong>: <br/>
                                        <em>Question:</em> {quiz.question} <br/>
                                        ❌ Your answer: <span className="wrong-answer">{quiz.user_answer}</span> <br/>
                                        ✅ Correct answer: <span className="correct-answer">{quiz.correct_answer}</span>
                                    </li>

                                ))}
                            </ul>
                        </div>
                    ))}
                </div>
            )}

            {showModal && (
                <div className="modal-overlay">
                    <div className="modal-window">
                    <p>Are you sure you want to clear progress?</p>
                        <div className="modal-buttons">
                            <button className="modal-confirm" onClick={confirmClearProgress}>Yes</button>
                            <button className="modal-cancel" onClick={() => setShowModal(false)}>Cancel</button>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
};

export default UserProgress;
