package com.skillquest.model;

import jakarta.persistence.*;

@Entity
@Table(name = "questions")
public class Question {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "course_id") private Long courseId;
    private String text;
    @Column(name = "options_json", columnDefinition = "JSON") private String optionsJson;
    @Column(name = "correct_index") private int correctIndex;

    public Long getId() { return id; }
    public Long getCourseId() { return courseId; }
    public String getText() { return text; }
    public String getOptionsJson() { return optionsJson; }
    public int getCorrectIndex() { return correctIndex; }
}
