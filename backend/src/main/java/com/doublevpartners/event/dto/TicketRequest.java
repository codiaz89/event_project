package com.doublevpartners.event.dto;

import com.doublevpartners.event.entity.TicketStatus;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.util.UUID;

public record TicketRequest(
    @NotBlank(message = "La descripción es obligatoria")
    @Size(max = 500, message = "La descripción no puede exceder 500 caracteres")
    String description,
    @NotNull(message = "El identificador del usuario es obligatorio")
    UUID userId,
    TicketStatus status
) {
}

