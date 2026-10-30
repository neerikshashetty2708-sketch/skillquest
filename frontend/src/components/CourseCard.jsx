export default function CourseCard({ course, enrolled, onEnroll }) {
  return (
    <div className="card">
      <span className="badge">{course.level}</span>
      <h3>{course.title}</h3>
      <p>{course.description}</p>
      <small>Instructor: {course.instructor}</small>
      <button disabled={enrolled} onClick={() => onEnroll(course.id)}>
        {enrolled ? 'Enrolled ✓' : 'Enroll'}
      </button>
    </div>
  );
}
