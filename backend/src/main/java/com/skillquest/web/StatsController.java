package com.skillquest.web;

import com.skillquest.config.GamificationService;
import com.skillquest.model.User;
import com.skillquest.repo.*;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class StatsController {
    private final UserRepository users;
    private final UserBadgeRepository userBadges;
    private final BadgeRepository badges;

    public StatsController(UserRepository u, UserBadgeRepository ub, BadgeRepository b) {
        this.users = u; this.userBadges = ub; this.badges = b;
    }

    @GetMapping("/me/stats")
    public Map<String, Object> stats(Authentication auth) {
        User u = users.findByEmail(auth.getName()).orElseThrow();
        List<Map<String, String>> earned = userBadges.findByUserId(u.getId()).stream()
            .flatMap(ub -> badges.findById(ub.getBadgeCode()).stream())
            .map(b -> Map.of("icon", b.getIcon(), "name", b.getName(), "description", b.getDescription()))
            .toList();
        return Map.of(
            "name", u.getName(),
            "xp", u.getXp(),
            "level", GamificationService.level(u.getXp()),
            "xpIntoLevel", u.getXp() % GamificationService.XP_PER_LEVEL,
            "xpPerLevel", GamificationService.XP_PER_LEVEL,
            "streak", u.getStreak(),
            "badges", earned);
    }

    @GetMapping("/leaderboard")
    public List<Map<String, Object>> leaderboard() {
        return users.findTop10ByOrderByXpDesc().stream()
            .map(u -> Map.<String, Object>of("name", u.getName(), "xp", u.getXp(),
                                             "level", GamificationService.level(u.getXp())))
            .toList();
    }
}
