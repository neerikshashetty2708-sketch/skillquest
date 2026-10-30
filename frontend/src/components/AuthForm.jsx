import { useState } from 'react';
import { api } from '../api.js';

export default function AuthForm({ onSuccess }) {
  const [mode, setMode] = useState('login');
  const [form, setForm] = useState({ name: '', email: '', password: '' });
  const [error, setError] = useState('');
  const set = (k) => (e) => setForm({ ...form, [k]: e.target.value });

  const submit = async (e) => {
    e.preventDefault();
    setError('');
    try {
      if (mode === 'register') await api.register(form);
      onSuccess(await api.login({ email: form.email, password: form.password }));
    } catch (err) { setError(err.message); }
  };

  return (
    <form className="card auth" onSubmit={submit}>
      <h2>{mode === 'login' ? 'Log in' : 'Create account'}</h2>
      {mode === 'register' && <input type="text" placeholder="Name" value={form.name} onChange={set('name')} required />}
      <input type="email" placeholder="Email" value={form.email} onChange={set('email')} required />
      <input type="password" placeholder="Password (6+ chars)" value={form.password} onChange={set('password')} required />
      {error && <p className="error">{error}</p>}
      <button type="submit">{mode === 'login' ? 'Log in' : 'Register'}</button>
      <a href="#" onClick={(e) => { e.preventDefault(); setMode(mode === 'login' ? 'register' : 'login'); }}>
        {mode === 'login' ? 'New here? Register' : 'Have an account? Log in'}
      </a>
    </form>
  );
}
