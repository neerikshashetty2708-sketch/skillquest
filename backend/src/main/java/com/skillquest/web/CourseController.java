package com.skillquest.web;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.skillquest.config.GamificationService;
import com.skillquest.model.Course;
import com.skillquest.model.Enrollment;
import com.skillquest.model.Question;
import com.skillquest.model.User;
import com.skillquest.repo.*;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/courses")
public class CourseController {
    record QuestionView(Long id, String text, List<String> options) {}

    private final CourseRepository courses;
    private final QuestionRepository questions;
    private final EnrollmentRepository enrollments;
    private final UserRepository users;
    private final GamificationService game;
    private final ObjectMapper mapper = new ObjectMapper();

    public CourseController(CourseRepository c, QuestionRepository q, EnrollmentRepository e,
                            UserRepository u, GamificationService g) {
        this.courses = c; this.questions = q; this.enrollments = e; this.users = u; this.game = g;
    }

    @GetMapping
    public List<Course> list() { return courses.findAll(); }

    @GetMapping("/{id}")
    public ResponseEntity<Course> get(@PathVariable Long id) {
        return courses.findById(id).map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
    }

    /** Questions are returned WITHOUT the correct answer. */
    @GetMapping("/{id}/quiz")
    public List<QuestionView> quiz(@PathVariable Long id) {
        return questions.findByCourseId(id).stream()
            .map(q -> new QuestionView(q.getId(), q.getText(), parse(q))).toList();
    }

    /** Body: { "answers": { "<questionId>": <selectedIndex> } }. XP is paid only for score improvements. */
    @PostMapping("/{id}/quiz/submit")
    public ResponseEntity<?> submit(@PathVariable Long id, @RequestBody Map<String, Map<String, Integer>> body,
                                    Authentication auth) {
        List<Question> qs = questions.findByCourseId(id);
        Map<String, Integer> answers = body.getOrDefault("answers", Map.of());
        int correct = 0;
        for (Question q : qs) {
            Integer a = answers.get(String.valueOf(q.getId()));
            if (a != null && a == q.getCorrectIndex()) correct++;
        }
        int score = qs.isEmpty() ? 0 : Math.round(100f * correct / qs.size());

        User u = users.findByEmail(auth.getName()).orElseThrow();
        List<String> earned = new ArrayList<>();
        int gained = 0;
        Optional<Enrollment> oe = enrollments.findByUserIdAndCourseId(u.getId(), id);
        if (oe.isPresent()) {
            Enrollment e = oe.get();
            int prev = e.getBestQuizScore() == null ? 0 : e.getBestQuizScore();
            if (score > prev) {
                gained = (score - prev) / 2;
                e.setBestQuizScore(score);
                enrollments.save(e);
                game.addXp(u, gained);
            }
            game.touchStreak(u, earned);
            if (score == 100) game.grant(u, "PERFECT", earned);
        }
        return ResponseEntity.ok(Map.of("correct", correct, "total", qs.size(), "score", score,
                                        "xpGained", gained, "newBadges", earned));
    }

    private List<String> parse(Question q) {
        try { return mapper.readValue(q.getOptionsJson(), new TypeReference<List<String>>() {}); }
        catch (Exception e) { return List.of(); }
    }
}
