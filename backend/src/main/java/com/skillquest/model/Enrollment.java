package com.skillquest.model;

import jakarta.persistence.*;

@Entity
@Table(name = "enrollments")
public class Enrollment {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "user_id") private Long userId;
    @Column(name = "course_id") private Long courseId;
    @Column(name = "progress_percent") private int progressPercent = 0;
    @Column(name = "best_quiz_score") private Integer bestQuizScore;

    public Long getId() { return id; }
    public Long getUserId() { return userId; }
    public void setUserId(Long u) { this.userId = u; }
    public Long getCourseId() { return courseId; }
    public void setCourseId(Long c) { this.courseId = c; }
    public int getProgressPercent() { return progressPercent; }
    public void setProgressPercent(int p) { this.progressPercent = p; }
    public Integer getBestQuizScore() { return bestQuizScore; }
    public void setBestQuizScore(Integer s) { this.bestQuizScore = s; }
}
