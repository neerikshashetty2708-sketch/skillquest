# SkillQuest – Gamified Online Learning Platform

React (Vite) → REST/JSON → Spring MVC (Spring Boot, Spring Security, JPA) → MySQL

## What makes it different
- XP and levels (100 XP per level), daily learning streaks, badges, public leaderboard
- Lessons per course; course progress is derived from completed lessons (server-side, not client-editable)
- Quiz XP only for score improvements (no XP farming); perfect scores earn a badge
- Gamification rules isolated in `GamificationService`
- Light/dark theme toggle

## Run
1. MySQL:    `mysql -u root -p < database/schema.sql`
2. Backend:  edit `backend/src/main/resources/application.properties`, then `cd backend && mvn spring-boot:run` (port 8080)
3. Frontend: `cd frontend && npm install && npm run dev` (port 5173, proxies /api to 8080)

## Architecture
- Presentation: React components (CourseList, CourseCard, CoursePlayer, Quiz, Dashboard, Leaderboard, AuthForm)
- Controllers (Spring MVC @RestController): Auth, Course, Lesson, Enrollment, Stats
- Service: GamificationService (XP, level, streak, badge rules)
- Persistence: Spring Data JPA → MySQL (users, courses, lessons, enrollments, lesson_completions, questions, badges, user_badges)

## API
POST /api/auth/register | /login | /logout, GET /api/auth/me
GET  /api/courses, /api/courses/{id}, /api/courses/{id}/lessons, /api/courses/{id}/quiz
POST /api/courses/{id}/quiz/submit, /api/lessons/{id}/complete, /api/enrollments/{courseId}
GET  /api/enrollments/me, /api/me/stats, /api/leaderboard

## Production notes
Enable CSRF protection (disabled for simplicity), use HTTPS + secure cookies, add validation (@Valid), pagination and an instructor role for course authoring.
