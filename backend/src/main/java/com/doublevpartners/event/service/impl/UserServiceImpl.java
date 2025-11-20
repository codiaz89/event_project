package com.doublevpartners.event.service.impl;

import com.doublevpartners.event.dto.UserRequest;
import com.doublevpartners.event.dto.UserResponse;
import com.doublevpartners.event.entity.UserEntity;
import com.doublevpartners.event.exception.NotFoundException;
import com.doublevpartners.event.mapper.UserMapper;
import com.doublevpartners.event.repository.UserRepository;
import com.doublevpartners.event.service.UserService;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final UserMapper userMapper;

    public UserServiceImpl(UserRepository userRepository, UserMapper userMapper) {
        this.userRepository = userRepository;
        this.userMapper = userMapper;
    }

    @Override
    public UserResponse createUser(UserRequest request) {
        UserEntity entity = userMapper.toEntity(request);
        UserEntity saved = userRepository.save(entity);
        return userMapper.toResponse(saved);
    }

    @Override
    public UserResponse updateUser(UUID userId, UserRequest request) {
        UserEntity entity = getEntity(userId);
        userMapper.updateEntity(entity, request);
        return userMapper.toResponse(userRepository.save(entity));
    }

    @Override
    @Transactional(readOnly = true)
    public List<UserResponse> getAllUsers() {
        return userRepository.findAll()
            .stream()
            .map(userMapper::toResponse)
            .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public UserResponse getUserById(UUID userId) {
        return userMapper.toResponse(getEntity(userId));
    }

    private UserEntity getEntity(UUID userId) {
        return userRepository.findById(userId)
            .orElseThrow(() -> new NotFoundException("Usuario no encontrado con id " + userId));
    }
}

