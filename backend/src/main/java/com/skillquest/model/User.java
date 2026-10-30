package com.skillquest.model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "users")
public class User {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    @Column(unique = true) private String email;
    @Column(name = "password_hash") private String passwordHash;
    private String role = "STUDENT";
    private int xp = 0;
    private int streak = 0;
    @Column(name = "last_active") private LocalDate lastActive;

    public Long getId() { return id; }
    public String getName() { return name; }
    public void setName(String n) { this.name = n; }
    public String getEmail() { return email; }
    public void setEmail(String e) { this.email = e; }
    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String p) { this.passwordHash = p; }
    public String getRole() { return role; }
    public void setRole(String r) { this.role = r; }
    public int getXp() { return xp; }
    public void setXp(int xp) { this.xp = xp; }
    public int getStreak() { return streak; }
    public void setStreak(int s) { this.streak = s; }
    public LocalDate getLastActive() { return lastActive; }
    public void setLastActive(LocalDate d) { this.lastActive = d; }
}
