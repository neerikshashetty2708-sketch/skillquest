import { useEffect, useState } from 'react';
import { api } from '../api.js';

export default function CoursePlayer({ course, onStats, onQuiz, onBack }) {
  const [lessons, setLessons] = useState([]);
  const [index, setIndex] = useState(0);
  const [toast, setToast] = useState('');

  useEffect(() => {
    api.lessons(course.courseId).then((l) => {
      setLessons(l);
      const firstTodo = l.findIndex((x) => !x.done);
      setIndex(firstTodo === -1 ? 0 : firstTodo);
    });
  }, [course]);

  if (lessons.length === 0) return <p>No lessons yet.</p>;

  const lesson = lessons[index];
  const doneCount = lessons.filter((l) => l.done).length;
  const pct = Math.round((100 * doneCount) / lessons.length);

  const complete = async () => {
    try {
      const r = await api.completeLesson(lesson.id);
      setLessons(lessons.map((l) => (l.id === lesson.id ? { ...l, done: true } : l)));
      const badges = r.newBadges.length ? ` · New badge: ${r.newBadges.join(', ')}` : '';
      setToast(r.xpGained > 0 ? `+${r.xpGained} XP${badges}` : 'Already completed');
      onStats();
    } catch (e) { setToast(e.message); }
  };

  return (
    <section>
      <button className="ghost" onClick={onBack}>← Back</button>
      <h2>{course.title}</h2>
      <div className="bar"><div style={{ width: `${pct}%` }} /></div>
      <small>{doneCount}/{lessons.length} lessons · {pct}%</small>

      <div className="player">
        <ul className="lesson-list">
          {lessons.map((l, i) => (
            <li key={l.id} className={i === index ? 'active' : ''} onClick={() => { setIndex(i); setToast(''); }}>
              {l.done ? '✅' : '⬜'} {l.title}
            </li>
          ))}
        </ul>
        <div className="card lesson">
          <h3>{lesson.title}</h3>
          <p>{lesson.content}</p>
          {toast && <p className="notice">{toast}</p>}
          <div>
            <button onClick={complete} disabled={lesson.done}>
              {lesson.done ? 'Completed ✓' : `Complete lesson (+${lesson.xp} XP)`}
            </button>
            {index < lessons.length - 1 && <button className="ghost" onClick={() => { setIndex(index + 1); setToast(''); }}>Next →</button>}
            {doneCount === lessons.length && <button onClick={onQuiz}>Take the quiz 🎯</button>}
          </div>
        </div>
      </div>
    </section>
  );
}
