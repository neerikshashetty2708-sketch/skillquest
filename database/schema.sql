CREATE DATABASE IF NOT EXISTS skillquest CHARACTER SET utf8mb4;
USE skillquest;

CREATE TABLE users (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  password_hash VARCHAR(100) NOT NULL,
  role ENUM('STUDENT','INSTRUCTOR','ADMIN') NOT NULL DEFAULT 'STUDENT',
  xp INT NOT NULL DEFAULT 0,
  streak INT NOT NULL DEFAULT 0,
  last_active DATE NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE courses (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(200) NOT NULL,
  description TEXT,
  instructor VARCHAR(100),
  level ENUM('BEGINNER','INTERMEDIATE','ADVANCED') DEFAULT 'BEGINNER',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE lessons (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  course_id BIGINT NOT NULL,
  title VARCHAR(200) NOT NULL,
  content TEXT,
  sort_order INT NOT NULL,
  xp INT NOT NULL DEFAULT 20,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

CREATE TABLE enrollments (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  course_id BIGINT NOT NULL,
  progress_percent INT NOT NULL DEFAULT 0,
  best_quiz_score INT NULL,
  enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_user_course (user_id, course_id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

CREATE TABLE lesson_completions (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  lesson_id BIGINT NOT NULL,
  completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_user_lesson (user_id, lesson_id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE
);

CREATE TABLE questions (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  course_id BIGINT NOT NULL,
  text VARCHAR(500) NOT NULL,
  options_json JSON NOT NULL,
  correct_index INT NOT NULL,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

CREATE TABLE badges (
  code VARCHAR(30) PRIMARY KEY,
  name VARCHAR(60) NOT NULL,
  description VARCHAR(200),
  icon VARCHAR(8) NOT NULL
);

CREATE TABLE user_badges (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  badge_code VARCHAR(30) NOT NULL,
  earned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_user_badge (user_id, badge_code),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (badge_code) REFERENCES badges(code)
);

-- ---------- Seed data ----------
INSERT INTO courses (title, description, instructor, level) VALUES
('React Fundamentals','Components, props, state and hooks.','A. Rao','BEGINNER'),
('Spring MVC in Practice','Controllers, JPA and security.','S. Iyer','INTERMEDIATE'),
('MySQL for Developers','Schema design, indexes and queries.','K. Reddy','BEGINNER');

INSERT INTO lessons (course_id, title, content, sort_order, xp) VALUES
(1,'What is a component?','A component is a reusable function that returns JSX. Split your UI into small pieces such as CourseCard or Quiz.',1,20),
(1,'Props and state','Props flow down from parent to child. State is data a component owns and can change with useState.',2,20),
(1,'Effects and data fetching','useEffect runs code after render. Use it to call your REST API when a component mounts.',3,30),
(2,'Controllers and routing','A @RestController maps HTTP requests to Java methods using @GetMapping, @PostMapping and friends.',1,20),
(2,'Spring Data JPA','Repositories give you CRUD with no SQL. Derived queries like findByEmail are generated from the method name.',2,25),
(2,'Securing the API','Spring Security hashes passwords with BCrypt and protects routes through a SecurityFilterChain.',3,30),
(3,'Designing tables','Choose keys carefully, normalise repeating data and use foreign keys to protect relationships.',1,20),
(3,'Indexes','Indexes speed up reads by avoiding full table scans, at a small cost on writes.',2,25);

INSERT INTO questions (course_id, text, options_json, correct_index) VALUES
(1,'Which hook manages local component state?','["useState","useFetch","useRoute","useStyle"]',0),
(1,'JSX stands for?','["Java Syntax Extension","JavaScript XML","JSON Extra","Joined Script X"]',1),
(2,'Which annotation marks a REST controller?','["@Service","@Entity","@RestController","@Bean"]',2),
(2,'Which algorithm does Spring Security commonly use for password hashing?','["MD5","BCrypt","Base64","CRC32"]',1),
(3,'What do indexes mainly improve?','["Read speed","Disk size","Password safety","Network latency"]',0);

INSERT INTO badges (code, name, description, icon) VALUES
('FIRST_STEP','First Step','Completed your first lesson','🚀'),
('COURSE_DONE','Course Conqueror','Finished every lesson in a course','🏆'),
('PERFECT','Perfectionist','Scored 100% on a quiz','🎯'),
('STREAK_3','On Fire','3-day learning streak','🔥'),
('STREAK_7','Unstoppable','7-day learning streak','⚡');
