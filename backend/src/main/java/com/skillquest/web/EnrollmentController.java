package com.skillquest.web;

import com.skillquest.model.Enrollment;
import com.skillquest.repo.*;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/enrollments")
public class EnrollmentController {
    private final EnrollmentRepository enrollments;
    private final CourseRepository courses;
    private final UserRepository users;
    private final LessonRepository lessons;
    private final LessonCompletionRepository completions;

    public EnrollmentController(EnrollmentRepository e, CourseRepository c, UserRepository u,
                                LessonRepository l, LessonCompletionRepository lc) {
        this.enrollments = e; this.courses = c; this.users = u; this.lessons = l; this.completions = lc;
    }

    private Long uid(Authentication a) { return users.findByEmail(a.getName()).orElseThrow().getId(); }

    @PostMapping("/{courseId}")
    public ResponseEntity<?> enroll(@PathVariable Long courseId, Authentication auth) {
        if (!courses.existsById(courseId)) return ResponseEntity.notFound().build();
        Long userId = uid(auth);
        if (enrollments.findByUserIdAndCourseId(userId, courseId).isPresent())
            return ResponseEntity.status(409).body(Map.of("error", "Already enrolled"));
        Enrollment e = new Enrollment();
        e.setUserId(userId); e.setCourseId(courseId);
        enrollments.save(e);
        return ResponseEntity.ok(Map.of("message", "Enrolled"));
    }

    /** Dashboard data. Progress is derived from completed lessons, never set by the client. */
    @GetMapping("/me")
    public List<Map<String, Object>> mine(Authentication auth) {
        Long userId = uid(auth);
        return enrollments.findByUserId(userId).stream().map(e -> {
            var c = courses.findById(e.getCourseId()).orElse(null);
            return Map.<String, Object>of(
                "courseId", e.getCourseId(),
                "title", c == null ? "(deleted)" : c.getTitle(),
                "progress", e.getProgressPercent(),
                "bestQuizScore", e.getBestQuizScore() == null ? -1 : e.getBestQuizScore(),
                "lessonsDone", completions.completedLessonIds(userId, e.getCourseId()).size(),
                "lessonsTotal", lessons.countByCourseId(e.getCourseId()));
        }).toList();
    }
}
