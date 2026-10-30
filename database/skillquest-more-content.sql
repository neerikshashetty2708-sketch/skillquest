-- SkillQuest: extra content. Run ONCE, with the skillquest database selected.
USE skillquest;

-- =====================================================================
-- Extra lessons and questions for the 3 existing courses
-- =====================================================================
SET @react = (SELECT id FROM courses WHERE title = 'React Fundamentals');
SET @spring = (SELECT id FROM courses WHERE title = 'Spring MVC in Practice');
SET @mysql = (SELECT id FROM courses WHERE title = 'MySQL for Developers');

INSERT INTO lessons (course_id, title, content, sort_order, xp) VALUES
(@react, 'Lists and keys', 'Use map() to turn an array of data into a list of components. Every item needs a unique, stable key so React can update the list efficiently.\n\nExample:\ncourses.map(c => <CourseCard key={c.id} course={c} />)\n\nAvoid using the array index as a key when items can be added, removed or reordered.', 4, 25),
(@react, 'Events and controlled forms', 'In React you handle events with props like onClick and onChange. A controlled input stores its value in state, so React is always the single source of truth.\n\nExample:\nconst [name, setName] = useState("");\n<input value={name} onChange={e => setName(e.target.value)} />', 5, 25),
(@react, 'Lifting state up', 'When two components need the same data, move the state to their closest common parent and pass it down as props. Children report changes back by calling functions passed in as props.\n\nIn SkillQuest, App holds the user and stats so the header, dashboard and quiz all stay in sync.', 6, 30),
(@spring, 'Request bodies and validation', 'Use @RequestBody to turn incoming JSON into a Java object, and @PathVariable to read values from the URL. Check input before saving it and return a clear status code such as 400 Bad Request when it is invalid.\n\nExample:\n@PostMapping("/register")\npublic ResponseEntity<?> register(@RequestBody RegisterRequest r) { ... }', 4, 25),
(@spring, 'Dependency injection', 'Spring creates objects (beans) and hands them to the classes that need them, usually through the constructor. This keeps classes loosely coupled and easy to test.\n\nExample:\npublic CourseController(CourseRepository courses) { this.courses = courses; }', 5, 25),
(@spring, 'Layered architecture', 'Keep responsibilities separate: controllers handle HTTP, services hold business rules, repositories talk to the database. In SkillQuest, GamificationService contains all XP and badge rules so controllers stay small.', 6, 30),
(@mysql, 'Joins', 'A JOIN combines rows from two tables using a related column. INNER JOIN returns only matching rows, LEFT JOIN keeps every row from the left table.\n\nExample:\nSELECT c.title, e.progress_percent\nFROM enrollments e\nJOIN courses c ON c.id = e.course_id\nWHERE e.user_id = 1;', 3, 25),
(@mysql, 'Transactions', 'A transaction groups several statements so they either all succeed or all fail. This protects data when something goes wrong halfway, for example awarding XP and saving a lesson completion together.\n\nExample:\nSTART TRANSACTION;\nUPDATE users SET xp = xp + 20 WHERE id = 1;\nCOMMIT;', 4, 25),
(@mysql, 'Normalisation', 'Normalisation removes repeated data by splitting it into related tables. Store each fact once and link tables with foreign keys. SkillQuest keeps badge details in badges and only stores the badge code in user_badges.', 5, 30);

INSERT INTO questions (course_id, text, options_json, correct_index) VALUES
(@react, 'Why does each item in a rendered list need a key?', '["To let React track items between renders","To style the item","To make the item clickable","To sort the list"]', 0),
(@react, 'What is a controlled input?', '["An input that is disabled","An input inside a form tag","An input whose value is stored in React state","An input that cannot be edited"]', 2),
(@react, 'How do you pass data from a parent to a child component?', '["Cookies","Props","Global CSS","SQL queries"]', 1),
(@spring, 'Which annotation reads a value from the URL path?', '["@RequestBody","@PathVariable","@Entity","@Bean"]', 1),
(@spring, 'What is the preferred way to inject dependencies in Spring?', '["Constructor injection","Static variables","Reading files","Global arrays"]', 0),
(@spring, 'Which layer should contain business rules such as awarding XP?', '["Repository","Service","Entity","Static resources"]', 1),
(@mysql, 'Which JOIN returns only rows that match in both tables?', '["LEFT JOIN","INNER JOIN","CROSS JOIN","OUTER LOOP"]', 1),
(@mysql, 'What does COMMIT do in a transaction?', '["Undoes the changes","Makes the changes permanent","Deletes the table","Creates an index"]', 1),
(@mysql, 'What is the goal of normalisation?', '["Remove repeated data","Make tables bigger","Disable foreign keys","Hide passwords"]', 0),
(@mysql, 'Which clause filters rows in a SELECT?', '["ORDER BY","GROUP BY","WHERE","LIMIT 1"]', 2);

-- =====================================================================
-- New course: Java Programming Basics
-- =====================================================================
INSERT INTO courses (title, description, instructor, level) VALUES
('Java Programming Basics', 'Types, control flow, classes and collections: the foundation for Spring.', 'M. Verma', 'BEGINNER');
SET @c = (SELECT id FROM courses WHERE title = 'Java Programming Basics');
INSERT INTO lessons (course_id, title, content, sort_order, xp) VALUES
(@c, 'Variables and data types', 'Java is statically typed: every variable has a type. Common types are int, double, boolean and String.\n\nExample:\nint age = 20;\ndouble price = 99.5;\nboolean active = true;\nString name = "Asha";', 1, 20),
(@c, 'Control flow', 'Use if/else to choose between paths and for or while loops to repeat work.\n\nExample:\nfor (int i = 1; i <= 3; i++) {\n  System.out.println("Lesson " + i);\n}', 2, 20),
(@c, 'Classes and objects', 'A class is a blueprint and an object is one instance of it. Classes bundle fields (data) with methods (behaviour). Use private fields with getters and setters to protect data.', 3, 25),
(@c, 'Collections', 'The collections framework provides ready-made data structures. ArrayList stores an ordered list, HashMap stores key-value pairs and HashSet stores unique values.\n\nExample:\nList<String> names = new ArrayList<>();\nnames.add("Asha");', 4, 25);
INSERT INTO questions (course_id, text, options_json, correct_index) VALUES
(@c, 'Which type stores true or false?', '["int","boolean","String","double"]', 1),
(@c, 'Which keyword creates a new object?', '["class","this","new","static"]', 2),
(@c, 'Which collection stores key-value pairs?', '["ArrayList","HashSet","HashMap","String"]', 2),
(@c, 'What does a for loop do?', '["Repeats a block of code","Declares a class","Imports a package","Stops the program"]', 0),
(@c, 'Why are fields often made private?', '["To protect data from direct outside access","To make code run faster","To avoid using methods","Because Java requires it"]', 0);

-- =====================================================================
-- New course: HTML and CSS Essentials
-- =====================================================================
INSERT INTO courses (title, description, instructor, level) VALUES
('HTML and CSS Essentials', 'Build clean, accessible and responsive web pages from scratch.', 'P. Nair', 'BEGINNER');
SET @c = (SELECT id FROM courses WHERE title = 'HTML and CSS Essentials');
INSERT INTO lessons (course_id, title, content, sort_order, xp) VALUES
(@c, 'Semantic HTML', 'Semantic tags describe the meaning of content: header, nav, main, section, article and footer. They help accessibility, search engines and readability compared with using div everywhere.', 1, 20),
(@c, 'Selectors and the box model', 'CSS selectors pick elements by tag, class (.card) or id (#menu). Every element is a box made of content, padding, border and margin.\n\nExample:\n.card { padding: 16px; border: 1px solid #ccc; margin: 8px; }', 2, 20),
(@c, 'Flexbox', 'Flexbox lays out items in a row or column. Set display: flex on the container, then use justify-content for the main axis and align-items for the cross axis.\n\nExample:\nnav { display: flex; justify-content: space-between; }', 3, 25),
(@c, 'Responsive design', 'Responsive pages adapt to any screen size. Use the viewport meta tag, flexible units like % and rem, and media queries.\n\nExample:\n@media (max-width: 700px) { .grid { grid-template-columns: 1fr; } }', 4, 25);
INSERT INTO questions (course_id, text, options_json, correct_index) VALUES
(@c, 'Which tag is best for the main navigation links?', '["<nav>","<div>","<span>","<b>"]', 0),
(@c, 'In the box model, which is the space outside the border that separates an element from others?', '["Padding","Margin","Content","Outline"]', 1),
(@c, 'Which CSS declaration turns an element into a flex container?', '["position: flex","float: flex","display: flex","flex: container"]', 2),
(@c, 'What does a CSS class selector start with?', '["#",".","@","$"]', 1),
(@c, 'Which feature applies styles only at certain screen widths?', '["Comments","Doctype","Iframes","Media queries"]', 3);

-- =====================================================================
-- New course: JavaScript Essentials
-- =====================================================================
INSERT INTO courses (title, description, instructor, level) VALUES
('JavaScript Essentials', 'Modern JavaScript: variables, functions, array methods and async code.', 'R. Sharma', 'BEGINNER');
SET @c = (SELECT id FROM courses WHERE title = 'JavaScript Essentials');
INSERT INTO lessons (course_id, title, content, sort_order, xp) VALUES
(@c, 'Variables and types', 'Use const for values that do not change and let for values that do. Avoid var. JavaScript types include string, number, boolean, null, undefined, object and array.\n\nExample:\nconst name = "Asha";\nlet score = 0;', 1, 20),
(@c, 'Functions and arrow functions', 'Functions package reusable logic. Arrow functions give a shorter syntax.\n\nExample:\nconst double = n => n * 2;\ndouble(4); // 8', 2, 20),
(@c, 'Array methods', 'map transforms every item, filter keeps matching items and reduce combines them into one value.\n\nExample:\n[1,2,3].map(n => n * 2); // [2,4,6]\n[1,2,3,4].filter(n => n % 2 === 0); // [2,4]', 3, 25),
(@c, 'Promises and async/await', 'Network calls take time, so JavaScript uses promises. With async/await you write asynchronous code that reads like normal code.\n\nExample:\nconst res = await fetch("/api/courses");\nconst data = await res.json();', 4, 30);
INSERT INTO questions (course_id, text, options_json, correct_index) VALUES
(@c, 'Which keyword declares a value that cannot be reassigned?', '["let","var","const","new"]', 2),
(@c, 'What does Array.map return?', '["A new array with transformed items","The first matching item","A number","Nothing"]', 0),
(@c, 'Which method keeps only the items that pass a test?', '["map","filter","push","join"]', 1),
(@c, 'What does await do inside an async function?', '["Deletes the promise","Runs code twice","Declares a variable","Pauses until a promise settles"]', 3),
(@c, 'What is the result of 2 + "2" in JavaScript?', '["4","22","NaN","Error"]', 1);

-- =====================================================================
-- New course: Git and GitHub
-- =====================================================================
INSERT INTO courses (title, description, instructor, level) VALUES
('Git and GitHub', 'Track changes, work in branches and collaborate through pull requests.', 'D. Menon', 'BEGINNER');
SET @c = (SELECT id FROM courses WHERE title = 'Git and GitHub');
INSERT INTO lessons (course_id, title, content, sort_order, xp) VALUES
(@c, 'What is version control?', 'Version control records every change to your files so you can see history, undo mistakes and collaborate safely. Git is a distributed system: every developer has a full copy of the repository.', 1, 20),
(@c, 'Commits and branches', 'A commit is a saved snapshot with a message. A branch is an independent line of work.\n\nCommands:\ngit add .\ngit commit -m "Add lesson page"\ngit switch -c feature/quiz', 2, 20),
(@c, 'Merging and conflicts', 'Merging combines branches. A conflict happens when two branches change the same lines. Git marks both versions in the file, you choose the final text, then commit the result.', 3, 25),
(@c, 'GitHub and pull requests', 'GitHub hosts repositories online. Push your branch, then open a pull request so teammates can review before it merges into main.\n\nCommand:\ngit push -u origin feature/quiz', 4, 25);
INSERT INTO questions (course_id, text, options_json, correct_index) VALUES
(@c, 'Which command saves a snapshot of staged changes?', '["git push","git commit","git clone","git status"]', 1),
(@c, 'What is a branch?', '["A deleted commit","A remote server","An independent line of development","A merge conflict"]', 2),
(@c, 'When does a merge conflict occur?', '["A file is too large","You forget a commit message","Git is not installed","Two branches change the same lines"]', 3),
(@c, 'What is a pull request used for?', '["Asking for review before merging","Downloading Git","Deleting a branch","Creating a database"]', 0),
(@c, 'Which command copies a remote repository to your computer?', '["git init","git clone","git merge","git stash"]', 1);

-- =====================================================================
-- New course: REST API Design
-- =====================================================================
INSERT INTO courses (title, description, instructor, level) VALUES
('REST API Design', 'Design clean URLs, use HTTP methods and status codes, and secure your API.', 'S. Iyer', 'INTERMEDIATE');
SET @c = (SELECT id FROM courses WHERE title = 'REST API Design');
INSERT INTO lessons (course_id, title, content, sort_order, xp) VALUES
(@c, 'Resources and URLs', 'REST models data as resources identified by URLs. Use nouns, not verbs, and plural names.\n\nGood: GET /api/courses/5\nAvoid: GET /api/getCourse?id=5', 1, 20),
(@c, 'HTTP methods', 'GET reads data, POST creates it, PUT replaces it, PATCH updates part of it and DELETE removes it. GET must never change data on the server.', 2, 25),
(@c, 'Status codes', 'Status codes tell the client what happened: 200 OK, 201 Created, 400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found, 409 Conflict and 500 Server Error. SkillQuest returns 409 when you enroll twice.', 3, 25),
(@c, 'Authentication basics', 'APIs must know who is calling. Passwords are stored as hashes (BCrypt), never as plain text. After login the server issues a session cookie or a token that the client sends with every request.', 4, 30);
INSERT INTO questions (course_id, text, options_json, correct_index) VALUES
(@c, 'Which HTTP method should create a new resource?', '["GET","POST","DELETE","HEAD"]', 1),
(@c, 'Which status code means the resource was not found?', '["200","401","404","500"]', 2),
(@c, 'Which URL follows REST naming conventions?', '["/api/getCourses","/api/courses","/api/course_list_all","/api/doCourses"]', 1),
(@c, 'Why should passwords be hashed?', '["So they are never stored as readable text","To make logins slower for users","To shorten the password","To send emails"]', 0),
(@c, 'Which status code means you are not logged in?', '["404 Not Found","201 Created","401 Unauthorized","409 Conflict"]', 2);

-- =====================================================================
-- New course: Data Structures and Algorithms
-- =====================================================================
INSERT INTO courses (title, description, instructor, level) VALUES
('Data Structures and Algorithms', 'Big O, core data structures, searching and sorting for interviews and exams.', 'V. Kulkarni', 'INTERMEDIATE');
SET @c = (SELECT id FROM courses WHERE title = 'Data Structures and Algorithms');
INSERT INTO lessons (course_id, title, content, sort_order, xp) VALUES
(@c, 'Big O notation', 'Big O describes how running time grows as input size n grows. O(1) is constant, O(log n) grows slowly, O(n) is linear and O(n^2) grows quickly. Choose algorithms with lower growth for large inputs.', 1, 25),
(@c, 'Arrays and linked lists', 'An array gives O(1) access by index but inserting in the middle is slow. A linked list inserts quickly once you have the node but needs O(n) to reach an item by position.', 2, 25),
(@c, 'Stacks and queues', 'A stack is last-in, first-out (LIFO), like the browser back button. A queue is first-in, first-out (FIFO), like a print queue. Both are built from arrays or linked lists.', 3, 25),
(@c, 'Searching and sorting', 'Linear search checks every item: O(n). Binary search halves a sorted list each step: O(log n). Merge sort and quick sort sort in about O(n log n) time.', 4, 30);
INSERT INTO questions (course_id, text, options_json, correct_index) VALUES
(@c, 'What is the time complexity of binary search?', '["O(n)","O(log n)","O(n^2)","O(1)"]', 1),
(@c, 'Which structure follows last-in, first-out order?', '["Stack","Queue","Array","Set"]', 0),
(@c, 'Accessing an array element by index takes?', '["O(n)","O(log n)","O(1)","O(n^2)"]', 2),
(@c, 'Which search requires the list to be sorted?', '["Linear search","Binary search","Stack push","Queue add"]', 1),
(@c, 'Which structure is first-in, first-out?', '["Stack","Tree","Heap","Queue"]', 3);

-- =====================================================================
-- Recalculate saved progress now that courses have more lessons
-- =====================================================================
UPDATE enrollments e
SET progress_percent = COALESCE(ROUND(100 *
  (SELECT COUNT(*) FROM lesson_completions lc JOIN lessons l ON l.id = lc.lesson_id
    WHERE lc.user_id = e.user_id AND l.course_id = e.course_id) /
  NULLIF((SELECT COUNT(*) FROM lessons l2 WHERE l2.course_id = e.course_id), 0)), 0);
