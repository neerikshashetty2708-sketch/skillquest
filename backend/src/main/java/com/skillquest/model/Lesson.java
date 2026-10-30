package com.skillquest.model;

import jakarta.persistence.*;

@Entity
@Table(name = "lessons")
public class Lesson {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "course_id") private Long courseId;
    private String title;
    @Column(columnDefinition = "TEXT") private String content;
    @Column(name = "sort_order") private int sortOrder;
    private int xp;

    public Long getId() { return id; }
    public Long getCourseId() { return courseId; }
    public String getTitle() { return title; }
    public String getContent() { return content; }
    public int getSortOrder() { return sortOrder; }
    public int getXp() { return xp; }
}
