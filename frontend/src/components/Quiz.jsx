import { useEffect, useState } from 'react';
import { api } from '../api.js';

export default function Quiz({ course, onStats, onDone }) {
  const [questions, setQuestions] = useState([]);
  const [answers, setAnswers] = useState({});
  const [result, setResult] = useState(null);

  useEffect(() => { api.quiz(course.courseId).then(setQuestions); }, [course]);

  const submit = async () => {
    setResult(await api.submitQuiz(course.courseId, answers));
    onStats();
  };

  if (result) {
    return (
      <div className="card">
        <h2>{result.score === 100 ? '🎯 Perfect! ' : ''}{result.correct}/{result.total} correct ({result.score}%)</h2>
        <p className="notice">
          {result.xpGained > 0 ? `+${result.xpGained} XP earned` : 'No new XP (beat your best score to earn more)'}
          {result.newBadges.length > 0 && ` · New badge: ${result.newBadges.join(', ')}`}
        </p>
        <button onClick={onDone}>Back to my quest</button>
      </div>
    );
  }

  return (
    <section>
      <h2>Quiz: {course.title}</h2>
      {questions.length === 0 && <p>No quiz available for this course yet.</p>}
      {questions.map((q, qi) => (
        <div className="card" key={q.id}>
          <p><b>{qi + 1}. {q.text}</b></p>
          {q.options.map((opt, i) => (
            <label key={i} className="option">
              <input type="radio" name={`q${q.id}`} checked={answers[q.id] === i}
                     onChange={() => setAnswers({ ...answers, [q.id]: i })} /> {opt}
            </label>
          ))}
        </div>
      ))}
      {questions.length > 0 && (
        <button onClick={submit} disabled={Object.keys(answers).length < questions.length}>Submit answers</button>
      )}
    </section>
  );
}
