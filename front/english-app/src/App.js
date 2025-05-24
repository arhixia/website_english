import React, { useState, useEffect } from "react";
import { BrowserRouter as Router, Routes, Route, Navigate } from "react-router-dom";
import { ToastContainer } from "react-toastify";
import Header from "./components/Header";
import Home from "./components/Home";
import LearningPage from "./components/LearningPage";
import TestPage from "./components/TestPage";
import TestsList from "./components/TestsList";
import UserProgress from "./components/UserProgress";

const PrivateRoute = ({ children, user }) => {
    return user && user.id ? children : <Navigate to="/" replace />;
};

function App() {
    const [user, setUser] = useState(null);

    useEffect(() => {
        const savedUsername = localStorage.getItem("username");
        const savedUserId = localStorage.getItem("user_id");

        if (savedUsername && savedUserId) {
            setUser({
                username: savedUsername,
                id: parseInt(savedUserId),
            });
        }
    }, []);

    return (
        <Router>
            <Header user={user} setUser={setUser} />
            <Routes>
                <Route path="/" element={<Home user={user} />} />
                <Route path="/learning" element={<LearningPage />} />
                <Route path="/tests" element={<TestsList />} />
                <Route path="/tests/:id" element={<TestPage />} />
                <Route
                    path="/user/:id/progress"
                    element={
                        <PrivateRoute user={user}>
                            <UserProgress />
                        </PrivateRoute>
                    }
                />
            </Routes>
            <ToastContainer />
        </Router>
    );
}

export default App;
