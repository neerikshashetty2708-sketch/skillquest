package com.skillquest.model;

import jakarta.persistence.*;

@Entity
@Table(name = "user_badges")
public class UserBadge {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "user_id") private Long userId;
    @Column(name = "badge_code") private String badgeCode;

    public Long getUserId() { return userId; }
    public void setUserId(Long u) { this.userId = u; }
    public String getBadgeCode() { return badgeCode; }
    public void setBadgeCode(String c) { this.badgeCode = c; }
}
