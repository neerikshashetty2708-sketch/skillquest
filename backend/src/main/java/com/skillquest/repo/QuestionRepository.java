package com.skillquest.repo;

import com.skillquest.model.Question;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface QuestionRepository extends JpaRepository<Question, Long> {
    List<Question> findByCourseId(Long courseId);
}
