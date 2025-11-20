package com.doublevpartners.event.mapper;

import com.doublevpartners.event.dto.UserRequest;
import com.doublevpartners.event.dto.UserResponse;
import com.doublevpartners.event.entity.UserEntity;
import org.springframework.stereotype.Component;

@Component
public class UserMapper {

    public UserEntity toEntity(UserRequest request) {
        UserEntity entity = new UserEntity();
        entity.setFirstName(request.firstName().trim());
        entity.setLastName(request.lastName().trim());
        return entity;
    }

    public void updateEntity(UserEntity entity, UserRequest request) {
        entity.setFirstName(request.firstName().trim());
        entity.setLastName(request.lastName().trim());
    }

    public UserResponse toResponse(UserEntity entity) {
        return new UserResponse(
            entity.getId(),
            entity.getFirstName(),
            entity.getLastName(),
            entity.getCreatedAt(),
            entity.getUpdatedAt()
        );
    }
}

