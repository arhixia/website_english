import React from "react";
import { useNavigate } from "react-router-dom";
import { toast } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import "./Home.css";

const Home = ({ user }) => {
    const navigate = useNavigate();

    const handleButtonClick = (path) => {
        if (user) {
            navigate(path);
        } else {
            toast.warn("Please log in to access this section!", {
                position: "top-center",
                autoClose: 3000,
                hideProgressBar: false,
                closeOnClick: true,
                pauseOnHover: true,
                draggable: true,
                theme: "colored",
            });
        }
    };

    return (
        <div className="home-page">
            <div className="home-container">
                <h1 className="home-title">Welcome to English Repeater!</h1>
                <p className="welcome-text">
                    📚 Here, you can review materials for each semester and reinforce your knowledge in a structured way.
                </p>
                <p className="welcome-text">
                    🎯 Test yourself with interactive quizzes, identify weak points, and track your progress.
                </p>
                <p className="welcome-text">
                    📝 Monitor your mistakes, analyze incorrect answers, and improve your skills step by step. The more
                    you practice, the better your results will be!
                </p>
                <p className="welcome-text">
                    🚀 Let's make learning effective, fun, and engaging!
                </p>

                {/* Кнопка прогресса */}
                {user && (
                    <div className="progress-container">
                        <button
                            className="progress-button"
                            onClick={() => handleButtonClick(`/user/${user.id}/progress`)}
                        >
                            Your Mistakes
                        </button>
                    </div>
                )}

                {/* Блок с кнопками обучения */}
                <div className="course-selection">
                    <h2 className="course-title">1st Course, 1st Semester</h2>
                    <div className="button-container">
                        <button className="course-button" onClick={() => handleButtonClick("/learning")}>
                            Learning Materials
                        </button>
                        <button className="course-button" onClick={() => handleButtonClick("/tests")}>
                            Tests
                        </button>
                    </div>
                </div>

                {/* Текст в правом нижнем углу */}
                <p className="bottom-text">
                    New tests and materials will appear here at the end of the semester.
                </p>
            </div>
        </div>
    );
};

export default Home;
