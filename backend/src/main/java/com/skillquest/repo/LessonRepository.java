package com.skillquest.repo;

import com.skillquest.model.Lesson;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface LessonRepository extends JpaRepository<Lesson, Long> {
    List<Lesson> findByCourseIdOrderBySortOrder(Long courseId);
    long countByCourseId(Long courseId);
}
