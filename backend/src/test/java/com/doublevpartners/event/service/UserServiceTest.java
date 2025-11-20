package com.doublevpartners.event.service;

import static org.assertj.core.api.Assertions.assertThat;

import com.doublevpartners.event.dto.UserRequest;
import com.doublevpartners.event.dto.UserResponse;
import java.util.List;
import java.util.UUID;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

@SpringBootTest
@ActiveProfiles("test")
class UserServiceTest {

    @Autowired
    private UserService userService;

    @Test
    void shouldCreateAndRetrieveUser() {
        UserRequest request = new UserRequest("Juan", "Pérez");
        UserResponse created = userService.createUser(request);

        assertThat(created.id()).isNotNull();
        assertThat(created.firstName()).isEqualTo("Juan");

        UserResponse fetched = userService.getUserById(created.id());
        assertThat(fetched.lastName()).isEqualTo("Pérez");

        List<UserResponse> users = userService.getAllUsers();
        assertThat(users).extracting(UserResponse::id).contains(created.id());
    }
}

