package com.doublevpartners.event.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;

@Schema(description = "Datos de entrada para crear o actualizar un usuario")
public record UserRequest(
    @Schema(description = "Nombre(s) del usuario", example = "Juan", required = true)
    @NotBlank(message = "El nombre es obligatorio")
    String firstName,
    @Schema(description = "Apellido(s) del usuario", example = "Pérez", required = true)
    @NotBlank(message = "El apellido es obligatorio")
    String lastName
) {
}

