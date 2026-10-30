package com.skillquest.web;

import com.skillquest.config.GamificationService;
import com.skillquest.model.Enrollment;
import com.skillquest.model.Lesson;
import com.skillquest.model.LessonCompletion;
import com.skillquest.model.User;
import com.skillquest.repo.*;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/api")
public class LessonController {
    record LessonView(Long id, String title, String content, int xp, boolean done) {}

    private final LessonRepository lessons;
    private final LessonCompletionRepository completions;
    private final EnrollmentRepository enrollments;
    private final UserRepository users;
    private final GamificationService game;

    public LessonController(LessonRepository l, LessonCompletionRepository c, EnrollmentRepository e,
                            UserRepository u, GamificationService g) {
        this.lessons = l; this.completions = c; this.enrollments = e; this.users = u; this.game = g;
    }

    @GetMapping("/courses/{courseId}/lessons")
    public List<LessonView> list(@PathVariable Long courseId, Authentication auth) {
        Long uid = users.findByEmail(auth.getName()).orElseThrow().getId();
        Set<Long> done = new HashSet<>(completions.completedLessonIds(uid, courseId));
        return lessons.findByCourseIdOrderBySortOrder(courseId).stream()
            .map(l -> new LessonView(l.getId(), l.getTitle(), l.getContent(), l.getXp(), done.contains(l.getId())))
            .toList();
    }

    /** Completing a lesson awards XP, updates the streak, recalculates course progress and may grant badges. */
    @PostMapping("/lessons/{lessonId}/complete")
    @Transactional
    public ResponseEntity<?> complete(@PathVariable Long lessonId, Authentication auth) {
        User u = users.findByEmail(auth.getName()).orElseThrow();
        Lesson lesson = lessons.findById(lessonId).orElse(null);
        if (lesson == null) return ResponseEntity.notFound().build();

        Optional<Enrollment> oe = enrollments.findByUserIdAndCourseId(u.getId(), lesson.getCourseId());
        if (oe.isEmpty()) return ResponseEntity.status(403).body(Map.of("error", "Enroll in the course first"));
        Enrollment e = oe.get();

        List<String> earned = new ArrayList<>();
        int gained = 0;
        if (!completions.existsByUserIdAndLessonId(u.getId(), lessonId)) {
            LessonCompletion lc = new LessonCompletion();
            lc.setUserId(u.getId()); lc.setLessonId(lessonId);
            completions.save(lc);

            gained = lesson.getXp();
            game.addXp(u, gained);
            game.touchStreak(u, earned);
            game.grant(u, "FIRST_STEP", earned);

            long total = lessons.countByCourseId(lesson.getCourseId());
            long done = completions.completedLessonIds(u.getId(), lesson.getCourseId()).size();
            e.setProgressPercent(total == 0 ? 0 : (int) Math.round(100.0 * done / total));
            enrollments.save(e);

            if (e.getProgressPercent() == 100) {
                game.grant(u, "COURSE_DONE", earned);
                game.addXp(u, 100); // course completion bonus
                gained += 100;
            }
        }
        return ResponseEntity.ok(Map.of("xpGained", gained, "progress", e.getProgressPercent(), "newBadges", earned));
    }
}
