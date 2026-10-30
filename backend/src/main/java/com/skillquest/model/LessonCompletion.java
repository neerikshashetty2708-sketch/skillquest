package com.skillquest.model;

import jakarta.persistence.*;

@Entity
@Table(name = "lesson_completions")
public class LessonCompletion {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "user_id") private Long userId;
    @Column(name = "lesson_id") private Long lessonId;

    public Long getId() { return id; }
    public Long getUserId() { return userId; }
    public void setUserId(Long u) { this.userId = u; }
    public Long getLessonId() { return lessonId; }
    public void setLessonId(Long l) { this.lessonId = l; }
}
