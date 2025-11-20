package com.doublevpartners.event.dto;

import java.time.LocalDateTime;

public record ApiError(
    LocalDateTime timestamp,
    String message,
    String path
) {
}

