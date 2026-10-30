package com.skillquest.repo;

import com.skillquest.model.LessonCompletion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;

public interface LessonCompletionRepository extends JpaRepository<LessonCompletion, Long> {
    boolean existsByUserIdAndLessonId(Long userId, Long lessonId);

    @Query("select lc.lessonId from LessonCompletion lc, Lesson l " +
           "where lc.lessonId = l.id and lc.userId = :uid and l.courseId = :cid")
    List<Long> completedLessonIds(@Param("uid") Long userId, @Param("cid") Long courseId);
}
