import { useEffect, useState } from 'react';
import { api } from '../api.js';
import CourseCard from './CourseCard.jsx';

export default function CourseList({ user, onLogin }) {
  const [courses, setCourses] = useState([]);
  const [enrolledIds, setEnrolledIds] = useState(new Set());
  const [query, setQuery] = useState('');
  const [msg, setMsg] = useState('');

  useEffect(() => { api.courses().then(setCourses); }, []);
  useEffect(() => {
    if (user) api.myEnrollments().then((l) => setEnrolledIds(new Set(l.map((e) => e.courseId))));
  }, [user]);

  const enroll = async (id) => {
    if (!user) return onLogin();
    try {
      await api.enroll(id);
      setEnrolledIds(new Set([...enrolledIds, id]));
      setMsg('Enrolled successfully!');
    } catch (e) { setMsg(e.message); }
  };

  const shown = courses.filter((c) => c.title.toLowerCase().includes(query.toLowerCase()));

  return (
    <section>
      <input className="search" placeholder="Search courses…" value={query} onChange={(e) => setQuery(e.target.value)} />
      {msg && <p className="notice">{msg}</p>}
      <div className="grid">
        {shown.map((c) => <CourseCard key={c.id} course={c} enrolled={enrolledIds.has(c.id)} onEnroll={enroll} />)}
      </div>
    </section>
  );
}
