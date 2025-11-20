package com.doublevpartners.event.dto;

import jakarta.validation.constraints.NotBlank;

public record UserRequest(
    @NotBlank(message = "El nombre es obligatorio")
    String firstName,
    @NotBlank(message = "El apellido es obligatorio")
    String lastName
) {
}

