package com.skillquest.repo;

import com.skillquest.model.Badge;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BadgeRepository extends JpaRepository<Badge, String> {}
