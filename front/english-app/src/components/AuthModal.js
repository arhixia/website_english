import React, { useState } from "react";
import Modal from "react-modal";
import "./AuthModal.css";
import { toast } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";

Modal.setAppElement("#root");

const AuthModal = ({ isOpen, onClose, onAuthSuccess }) => {
    const [username, setUsername] = useState("");
    const [password, setPassword] = useState("");
    const [error, setError] = useState("");
    const [isLogin, setIsLogin] = useState(true);
    const [showPassword, setShowPassword] = useState(false);

    const handleSubmit = async (e) => {
        e.preventDefault();
        setError("");

        const url = isLogin ? "http://127.0.0.1:8000/token" : "http://127.0.0.1:8000/register";
        const method = "POST";
        const requestData = { username, password };

        try {
            const response = await fetch(url, {
                method,
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(requestData),
            });

            const data = await response.json();

            if (!response.ok) {
                throw new Error(data.detail || "Ошибка авторизации");
            }

            if (isLogin) {
                localStorage.setItem("token", data.access_token);
                localStorage.setItem("username", username);
                localStorage.setItem("user_id", data.user_id);
                // Передаём username и user_id
                onAuthSuccess(username, data.user_id);
            } else {
                if (isLogin) {
    localStorage.setItem("token", data.access_token);
    localStorage.setItem("username", username);
    localStorage.setItem("user_id", data.user_id);
    onAuthSuccess(username, data.user_id);
} else {
    toast.success("Registration successful! Now log in.", {
        position: "top-center",
        autoClose: 3000,
        hideProgressBar: false,
        closeOnClick: true,
        pauseOnHover: true,
        draggable: true,
        theme: "colored",
    });
    setIsLogin(true);
}

                setIsLogin(true);
            }

            onClose();
        } catch (err) {
            setError(err.message);
        }
    };

    return (
        <Modal isOpen={isOpen} onRequestClose={onClose} className="modal" overlayClassName="overlay">
            <h2>{isLogin ? "Login" : "Sign in"}</h2>
            {error && <p className="error">{error}</p>}
            <form onSubmit={handleSubmit}>
                <input
                    type="text"
                    placeholder="Login"
                    value={username}
                    onChange={(e) => setUsername(e.target.value)}
                    required
                />
                <div className="password-container">
                    <input
                        type={showPassword ? "text" : "password"}
                        placeholder="Password"
                        value={password}
                        onChange={(e) => setPassword(e.target.value)}
                        required
                    />
                    <button
                        type="button"
                        className="toggle-password"
                        onClick={() => setShowPassword(!showPassword)}
                    >
                        {showPassword ? "Hide password" : "Show password"}
                    </button>
                </div>
                <button type="submit">{isLogin ? "Login" : "Sign in"}</button>
            </form>
            <p className="toggle" onClick={() => setIsLogin(!isLogin)}>
                {isLogin ? "Don't have an account? Register" : "Already have an account? Login"}
            </p>
        </Modal>
    );
};

export default AuthModal;
