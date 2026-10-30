package com.skillquest.config;

import com.skillquest.model.User;
import com.skillquest.model.UserBadge;
import com.skillquest.repo.BadgeRepository;
import com.skillquest.repo.UserBadgeRepository;
import com.skillquest.repo.UserRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

/** All XP, level, streak and badge rules live here so controllers stay thin. */
@Service
public class GamificationService {
    public static final int XP_PER_LEVEL = 100;
    private static final int BADGE_BONUS_XP = 25;

    private final UserRepository users;
    private final UserBadgeRepository userBadges;
    private final BadgeRepository badges;

    public GamificationService(UserRepository users, UserBadgeRepository userBadges, BadgeRepository badges) {
        this.users = users; this.userBadges = userBadges; this.badges = badges;
    }

    public static int level(int xp) { return xp / XP_PER_LEVEL + 1; }

    public void addXp(User u, int amount) {
        u.setXp(u.getXp() + amount);
        users.save(u);
    }

    /** Call on any learning activity: extends the daily streak or restarts it. */
    public void touchStreak(User u, List<String> earned) {
        LocalDate today = LocalDate.now();
        LocalDate last = u.getLastActive();
        if (today.equals(last)) return;
        u.setStreak(last != null && last.equals(today.minusDays(1)) ? u.getStreak() + 1 : 1);
        u.setLastActive(today);
        users.save(u);
        if (u.getStreak() >= 3) grant(u, "STREAK_3", earned);
        if (u.getStreak() >= 7) grant(u, "STREAK_7", earned);
    }

    /** Awards a badge once; adds its display text to `earned` and gives bonus XP. */
    public void grant(User u, String code, List<String> earned) {
        if (userBadges.existsByUserIdAndBadgeCode(u.getId(), code)) return;
        UserBadge ub = new UserBadge();
        ub.setUserId(u.getId());
        ub.setBadgeCode(code);
        userBadges.save(ub);
        badges.findById(code).ifPresent(b -> earned.add(b.getIcon() + " " + b.getName()));
        addXp(u, BADGE_BONUS_XP);
    }
}
