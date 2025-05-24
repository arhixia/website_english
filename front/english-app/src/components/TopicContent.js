import React from 'react';
import topicData from '../data/topicData'; // проверь путь, если `topicData.js` лежит в `src`

function TopicContent({ topicId }) {
  return (
    <div dangerouslySetInnerHTML={{ __html: topicData[topicId] }} />
  );
}

export default TopicContent;
