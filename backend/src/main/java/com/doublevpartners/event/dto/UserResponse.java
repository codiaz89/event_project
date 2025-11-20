package com.doublevpartners.event.dto;

import java.time.LocalDateTime;
import java.util.UUID;

public record UserResponse(
    UUID id,
    String firstName,
    String lastName,
    LocalDateTime createdAt,
    LocalDateTime updatedAt
) {
}

