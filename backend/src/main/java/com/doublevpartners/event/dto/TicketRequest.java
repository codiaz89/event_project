package com.doublevpartners.event.dto;

import com.doublevpartners.event.entity.TicketStatus;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.util.UUID;

@Schema(description = "Datos de entrada para crear o actualizar un ticket")
public record TicketRequest(
    @Schema(description = "Descripción del ticket (máximo 500 caracteres)", 
        example = "Problema con acceso al sistema de reportes", required = true, maxLength = 500)
    @NotBlank(message = "La descripción es obligatoria")
    @Size(max = 500, message = "La descripción no puede exceder 500 caracteres")
    String description,
    @Schema(description = "ID del usuario que genera el ticket", 
        example = "123e4567-e89b-12d3-a456-426614174000", required = true)
    @NotNull(message = "El identificador del usuario es obligatorio")
    UUID userId,
    @Schema(description = "Estado del ticket", example = "ABIERTO", allowableValues = {"ABIERTO", "CERRADO"})
    TicketStatus status
) {
}

