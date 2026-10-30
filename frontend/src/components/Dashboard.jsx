import { useEffect, useState } from 'react';
import { api } from '../api.js';

export default function Dashboard({ stats, onLearn, onQuiz }) {
  const [items, setItems] = useState([]);
  useEffect(() => { api.myEnrollments().then(setItems); }, []);

  return (
    <section>
      {stats && (
        <div className="card hero">
          <h2>Welcome back, {stats.name}!</h2>
          <div className="stats">
            <div><b>Level {stats.level}</b><small>{stats.xp} XP total</small></div>
            <div><b>🔥 {stats.streak}</b><small>day streak</small></div>
            <div><b>{stats.badges.length}</b><small>badges</small></div>
          </div>
          <div className="bar xp"><div style={{ width: `${(100 * stats.xpIntoLevel) / stats.xpPerLevel}%` }} /></div>
          <small>{stats.xpPerLevel - stats.xpIntoLevel} XP to Level {stats.level + 1}</small>
          <div className="badges">
            {stats.badges.length === 0 && <small>Complete a lesson to earn your first badge!</small>}
            {stats.badges.map((b) => (
              <span key={b.name} className="badge-pill" title={b.description}>{b.icon} {b.name}</span>
            ))}
          </div>
        </div>
      )}

      <h2>My Courses</h2>
      {items.length === 0 && <p>You haven't enrolled in any courses yet.</p>}
      {items.map((i) => (
        <div className="card" key={i.courseId}>
          <h3>{i.title}</h3>
          <div className="bar"><div style={{ width: `${i.progress}%` }} /></div>
          <small>{i.lessonsDone}/{i.lessonsTotal} lessons · Best quiz: {i.bestQuizScore < 0 ? '—' : i.bestQuizScore + '%'}</small>
          <div>
            <button onClick={() => onLearn(i)}>{i.progress === 0 ? 'Start' : 'Continue'} learning</button>
            <button className="ghost" onClick={() => onQuiz(i)}>Take quiz</button>
          </div>
        </div>
      ))}
    </section>
  );
}
