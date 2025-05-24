import React from "react";
import { topics, topicContent } from "../data/topicData";
import "./LearningPage.css";

const LearningPage = () => {
    const scrollToTopic = (id) => {
        const element = document.getElementById(id);
        if (element) {
            element.scrollIntoView({ behavior: "smooth", block: "start" });
        }
    };

    return (
        <div className="learning-container">
            <h1>Learning Materials</h1>

            {/* Список тем */}
            <div className="topic-list">
                {topics.map((topic) => (
                    <button key={topic.id} onClick={() => scrollToTopic(topic.id)} className="topic-button">
                        {topic.id} {topic.title}
                    </button>
                ))}
            </div>

            {/* Контент для каждой темы */}
            <div className="content">
                {topics.map((topic) => (
                    <div key={topic.id} id={topic.id} className="topic-section">
                        <h2>{topic.id} {topic.title}</h2>
                        <div dangerouslySetInnerHTML={{ __html: topicContent[topic.id] || "Content will be added soon..." }} />
                    </div>
                ))}
            </div>
        </div>
    );
};

export default LearningPage;
