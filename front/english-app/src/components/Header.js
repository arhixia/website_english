import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import "./Header.css";
import AuthModal from "./AuthModal";
import logo from "./tgu_logo.png";

const Header = ({ user, setUser }) => {
    const [isModalOpen, setIsModalOpen] = useState(false);
    const navigate = useNavigate();


    useEffect(() => {
        const token = localStorage.getItem("token");
        if (token) {
            verifyUserToken(token);
        }
    }, []);

    const verifyUserToken = async (token) => {
        try {
            const response = await fetch(`http://127.0.0.1:8000/verify-token/${token}`, {
                headers: { Authorization: `Bearer ${token}` },
            });

            if (!response.ok) throw new Error("Токен недействителен");

            const data = await response.json();
            setUser({
                username: data.username,
                id: data.user_id || localStorage.getItem("user_id") || null,
            });
        } catch (error) {
            console.error("Ошибка проверки токена:", error);
            localStorage.removeItem("token");
            localStorage.removeItem("username");
            localStorage.removeItem("user_id");
            setUser(null);
        }
    };

    const handleLogout = async () => {
        const token = localStorage.getItem("token");

        if (!token) {
            setUser(null);
            return;
        }

        try {
            const response = await fetch("http://127.0.0.1:8000/logout", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    Authorization: `Bearer ${token}`,
                },
            });

            if (!response.ok) {
                throw new Error("Ошибка при выходе");
            }

            localStorage.removeItem("token");
            localStorage.removeItem("username");
            localStorage.removeItem("user_id");
            setUser(null);
            navigate("/");
        } catch (error) {
            console.error("Ошибка при выходе:", error);
        }
    };

    return (
        <header className="header">
            <div className="logo-container">
                <div className="logo" onClick={() => navigate("/")}>
                    English Repeater
                </div>
            </div>
            <div className="logo-image-container">
                <img src={logo} alt="Logo" className="logo-image" onClick={() => navigate("/")}/>
            </div>
            <div className="auth-buttons">
                {user ? (
                    <>
                        <span className="username">{user.username}</span>
                        <button className="logout-button" onClick={handleLogout}>Sign out</button>
                    </>
                ) : (
                    <button
                        className={`auth-button ${isModalOpen ? "active" : ""}`}
                        onClick={() => setIsModalOpen(true)}
                    >
                        Login / Sign in
                    </button>
                )}
            </div>

            <AuthModal
                isOpen={isModalOpen}
                onClose={() => setIsModalOpen(false)}
                onAuthSuccess={(username, userId) => {
                    setUser({ username, id: userId });
                    localStorage.setItem("username", username);
                    localStorage.setItem("user_id", userId);
                }}
            />
        </header>
    );
};

export default Header;
