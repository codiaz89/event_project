package com.doublevpartners.event.repository;

import com.doublevpartners.event.entity.UserEntity;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<UserEntity, UUID> {
}

