async function request(path, options = {}) {
  const res = await fetch('/api' + path, {
    credentials: 'include',
    headers: { 'Content-Type': 'application/json' },
    ...options,
    body: options.body ? JSON.stringify(options.body) : undefined
  });
  const data = await res.json().catch(() => ({}));
  if (!res.ok) throw new Error(data.error || `Request failed (${res.status})`);
  return data;
}

export const api = {
  register: (b) => request('/auth/register', { method: 'POST', body: b }),
  login: (b) => request('/auth/login', { method: 'POST', body: b }),
  logout: () => request('/auth/logout', { method: 'POST' }),
  me: () => request('/auth/me'),
  courses: () => request('/courses'),
  lessons: (courseId) => request(`/courses/${courseId}/lessons`),
  completeLesson: (id) => request(`/lessons/${id}/complete`, { method: 'POST' }),
  quiz: (id) => request(`/courses/${id}/quiz`),
  submitQuiz: (id, answers) => request(`/courses/${id}/quiz/submit`, { method: 'POST', body: { answers } }),
  enroll: (id) => request(`/enrollments/${id}`, { method: 'POST' }),
  myEnrollments: () => request('/enrollments/me'),
  stats: () => request('/me/stats'),
  leaderboard: () => request('/leaderboard')
};
