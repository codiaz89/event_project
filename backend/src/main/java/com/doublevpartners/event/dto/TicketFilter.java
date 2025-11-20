package com.doublevpartners.event.dto;

import com.doublevpartners.event.entity.TicketStatus;
import java.util.UUID;

public record TicketFilter(
    TicketStatus status,
    UUID userId
) {
    public boolean hasStatus() {
        return status != null;
    }

    public boolean hasUser() {
        return userId != null;
    }
}

