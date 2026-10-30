package com.skillquest.model;

import jakarta.persistence.*;

@Entity
@Table(name = "badges")
public class Badge {
    @Id private String code;
    private String name;
    private String description;
    private String icon;

    public String getCode() { return code; }
    public String getName() { return name; }
    public String getDescription() { return description; }
    public String getIcon() { return icon; }
}
