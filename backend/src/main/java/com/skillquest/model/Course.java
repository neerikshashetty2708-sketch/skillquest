package com.skillquest.model;

import jakarta.persistence.*;

@Entity
@Table(name = "courses")
public class Course {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String title;
    @Column(columnDefinition = "TEXT") private String description;
    private String instructor;
    private String level;

    public Long getId() { return id; }
    public String getTitle() { return title; }
    public String getDescription() { return description; }
    public String getInstructor() { return instructor; }
    public String getLevel() { return level; }
}
