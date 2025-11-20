package com.doublevpartners.event.service;

import com.doublevpartners.event.dto.UserRequest;
import com.doublevpartners.event.dto.UserResponse;
import java.util.List;
import java.util.UUID;

public interface UserService {

    UserResponse createUser(UserRequest request);

    UserResponse updateUser(UUID userId, UserRequest request);

    List<UserResponse> getAllUsers();

    UserResponse getUserById(UUID userId);
}

