import React, { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import "./styles.css"; // Подключаем CSS

const TestsList = () => {
    const [tests, setTests] = useState([]);
    const navigate = useNavigate();

    useEffect(() => {
        fetch("http://localhost:8000/tests/1") // Заменить на реальный эндпоинт
            .then((res) => res.json())
            .then((data) => {
                const testList = [
                    { id: 1, title: "Test 1" },
                    { id: 2, title: "Test 2" },
                    { id: 3, title: "Test 3" },
                    { id: 4, title: "Test 4" },
                ];
                setTests(testList);
            })
            .catch((error) => console.error("Error fetching tests:", error));
    }, []);

    return (
        <div className="tests-container">
            <h2 className="tests-title">Select a test:</h2>
            {tests.map((test) => (
                <button
                    key={test.id}
                    className="test-button"
                    onClick={() => navigate(`/tests/${test.id}`)}
                >
                    {test.title}
                </button>
            ))}
        </div>
    );
};

export default TestsList;
