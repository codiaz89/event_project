package com.doublevpartners.event.dto;

import com.doublevpartners.event.entity.TicketStatus;
import java.time.LocalDateTime;
import java.util.UUID;

public record TicketResponse(
    UUID id,
    String description,
    TicketStatus status,
    UUID userId,
    String userFullName,
    LocalDateTime createdAt,
    LocalDateTime updatedAt
) {
}

