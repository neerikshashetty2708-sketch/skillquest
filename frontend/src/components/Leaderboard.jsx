import { useEffect, useState } from 'react';
import { api } from '../api.js';

const medals = ['🥇', '🥈', '🥉'];

export default function Leaderboard({ me }) {
  const [rows, setRows] = useState([]);
  useEffect(() => { api.leaderboard().then(setRows); }, []);

  return (
    <section>
      <h2>🏅 Top Learners</h2>
      <div className="card">
        {rows.map((r, i) => (
          <div key={i} className={'row' + (r.name === me.name ? ' me' : '')}>
            <span>{medals[i] || i + 1}</span>
            <span className="grow">{r.name}</span>
            <span>Lv {r.level}</span>
            <b>{r.xp} XP</b>
          </div>
        ))}
      </div>
    </section>
  );
}
