// import { useCallback, useEffect, useState } from 'react';
// import { api } from './api.js';
// import AuthForm from './components/AuthForm.jsx';
// import CourseList from './components/CourseList.jsx';
// import Dashboard from './components/Dashboard.jsx';
// import CoursePlayer from './components/CoursePlayer.jsx';
// import Quiz from './components/Quiz.jsx';
// import Leaderboard from './components/Leaderboard.jsx';

// export default function App() {
//   const [user, setUser] = useState(null);
//   const [stats, setStats] = useState(null);
//   const [view, setView] = useState('courses'); // courses | login | dashboard | lessons | quiz | leaderboard
//   const [activeCourse, setActiveCourse] = useState(null);
//   const [theme, setTheme] = useState('light');

//   useEffect(() => { document.documentElement.dataset.theme = theme; }, [theme]);

//   const refreshStats = useCallback(() => {
//     api.stats().then(setStats).catch(() => setStats(null));
//   }, []);

//   useEffect(() => {
//     api.me().then((u) => { setUser(u); refreshStats(); }).catch(() => setUser(null));
//   }, [refreshStats]);

//   const onLogin = (u) => { setUser(u); refreshStats(); setView('courses'); };
//   const logout = async () => { await api.logout(); setUser(null); setStats(null); setView('courses'); };
//   const open = (course, next) => { setActiveCourse(course); setView(next); };

//   return (
//     <div className="app">
//       <header>
//         <h1>⚔️ SkillQuest</h1>
//         <nav>
//           <button onClick={() => setView('courses')}>Courses</button>
//           {user && <button onClick={() => { refreshStats(); setView('dashboard'); }}>My Quest</button>}
//           {user && <button onClick={() => setView('leaderboard')}>Leaderboard</button>}
//           {stats && <span className="chip">Lv {stats.level} · {stats.xp} XP · 🔥 {stats.streak}</span>}
//           <button onClick={() => setTheme(theme === 'light' ? 'dark' : 'light')} title="Toggle theme">
//             {theme === 'light' ? '🌙' : '☀️'}
//           </button>
//           {user ? <button onClick={logout}>Logout</button> : <button onClick={() => setView('login')}>Login</button>}
//         </nav>
//       </header>
//       <main>
//         {view === 'login' && !user && <AuthForm onSuccess={onLogin} />}
//         {view === 'courses' && <CourseList user={user} onLogin={() => setView('login')} />}
//         {view === 'dashboard' && user && (
//           <Dashboard stats={stats} onLearn={(c) => open(c, 'lessons')} onQuiz={(c) => open(c, 'quiz')} />
//         )}
//         {view === 'lessons' && activeCourse && (
//           <CoursePlayer course={activeCourse} onStats={refreshStats}
//                         onQuiz={() => setView('quiz')} onBack={() => setView('dashboard')} />
//         )}
//         {view === 'quiz' && activeCourse && (
//           <Quiz course={activeCourse} onStats={refreshStats} onDone={() => setView('dashboard')} />
//         )}
//         {view === 'leaderboard' && user && <Leaderboard me={user} />}
//       </main>
//     </div>
//   );
// }
 import { useCallback, useEffect, useState } from 'react';
import { api } from './api.js';
import AuthForm from './components/AuthForm.jsx';
import CourseList from './components/CourseList.jsx';
import Dashboard from './components/Dashboard.jsx';
import CoursePlayer from './components/CoursePlayer.jsx';
import Quiz from './components/Quiz.jsx';
import Leaderboard from './components/Leaderboard.jsx';

const PROTECTED = ['dashboard', 'lessons', 'quiz', 'leaderboard'];

export default function App() {
  const [user, setUser] = useState(null);
  const [stats, setStats] = useState(null);
  const [view, setView] = useState('courses');
  const [activeCourse, setActiveCourse] = useState(null);
  const [theme, setTheme] = useState('light');

  useEffect(() => { document.documentElement.dataset.theme = theme; }, [theme]);

  // Change screen AND record it in the browser history so Back works
  const navigate = useCallback((next, course = null, replace = false) => {
    const cur = window.history.state;
    if (!replace && cur && cur.view === next && cur.course?.courseId === course?.courseId) return;
    const state = { view: next, course };
    if (replace) window.history.replaceState(state, '', '#' + next);
    else window.history.pushState(state, '', '#' + next);
    setView(next);
    setActiveCourse(course);
  }, []);

  // Handle the browser Back / Forward buttons
  useEffect(() => {
    window.history.replaceState({ view: 'courses', course: null }, '', '#courses');
    const onPop = (e) => {
      setView(e.state?.view || 'courses');
      setActiveCourse(e.state?.course || null);
    };
    window.addEventListener('popstate', onPop);
    return () => window.removeEventListener('popstate', onPop);
  }, []);

  const refreshStats = useCallback(() => {
    api.stats().then(setStats).catch(() => setStats(null));
  }, []);

  useEffect(() => {
    api.me().then((u) => { setUser(u); refreshStats(); }).catch(() => setUser(null));
  }, [refreshStats]);

  const onLogin = (u) => { setUser(u); refreshStats(); navigate('courses', null, true); };
  const logout = async () => { await api.logout(); setUser(null); setStats(null); navigate('courses', null, true); };

  // Never show pages that need a login to a logged-out user (e.g. after Back)
  const current = (PROTECTED.includes(view) && !user) || (view === 'login' && user) ? 'courses' : view;

  return (
    <div className="app">
      <header>
        <h1>⚔️ SkillQuest</h1>
        <nav>
          <button onClick={() => navigate('courses')}>Courses</button>
          {user && <button onClick={() => { refreshStats(); navigate('dashboard'); }}>My Quest</button>}
          {user && <button onClick={() => navigate('leaderboard')}>Leaderboard</button>}
          {stats && <span className="chip">Lv {stats.level} · {stats.xp} XP · 🔥 {stats.streak}</span>}
          <button onClick={() => setTheme(theme === 'light' ? 'dark' : 'light')} title="Toggle theme">
            {theme === 'light' ? '🌙' : '☀️'}
          </button>
          {user ? <button onClick={logout}>Logout</button> : <button onClick={() => navigate('login')}>Login</button>}
        </nav>
      </header>
      <main>
        {current === 'login' && <AuthForm onSuccess={onLogin} />}
        {current === 'courses' && <CourseList user={user} onLogin={() => navigate('login')} />}
        {current === 'dashboard' && (
          <Dashboard stats={stats} onLearn={(c) => navigate('lessons', c)} onQuiz={(c) => navigate('quiz', c)} />
        )}
        {current === 'lessons' && activeCourse && (
          <CoursePlayer course={activeCourse} onStats={refreshStats}
                        onQuiz={() => navigate('quiz', activeCourse)} onBack={() => navigate('dashboard')} />
        )}
        {current === 'quiz' && activeCourse && (
          <Quiz course={activeCourse} onStats={refreshStats} onDone={() => navigate('dashboard')} />
        )}
        {current === 'leaderboard' && <Leaderboard me={user} />}
      </main>
    </div>
  );
}