package com.doublevpartners.event.controller;

import com.doublevpartners.event.dto.ApiError;
import com.doublevpartners.event.exception.NotFoundException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.ConstraintViolationException;
import java.time.LocalDateTime;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

@RestControllerAdvice
public class GlobalExceptionHandler extends ResponseEntityExceptionHandler {

    @Override
    protected ResponseEntity<Object> handleMethodArgumentNotValid(
        MethodArgumentNotValidException ex,
        HttpHeaders headers,
        HttpStatusCode status,
        WebRequest request
    ) {
        String message = ex.getBindingResult()
            .getFieldErrors()
            .stream()
            .findFirst()
            .map(error -> error.getField() + ": " + error.getDefaultMessage())
            .orElse("Solicitud inválida");
        return buildResponseEntity(message, status.value(), request.getDescription(false));
    }

    @Override
    protected ResponseEntity<Object> handleBindException(
        BindException ex,
        HttpHeaders headers,
        HttpStatusCode status,
        WebRequest request
    ) {
        String message = ex.getBindingResult()
            .getFieldErrors()
            .stream()
            .findFirst()
            .map(error -> error.getField() + ": " + error.getDefaultMessage())
            .orElse("Solicitud inválida");
        return buildResponseEntity(message, status.value(), request.getDescription(false));
    }

    @ExceptionHandler(ConstraintViolationException.class)
    public ResponseEntity<Object> handleConstraintViolation(ConstraintViolationException exception, HttpServletRequest request) {
        String message = exception.getConstraintViolations()
            .stream()
            .findFirst()
            .map(violation -> violation.getPropertyPath() + ": " + violation.getMessage())
            .orElse("Solicitud inválida");
        return buildResponseEntity(message, HttpStatus.BAD_REQUEST.value(), request.getRequestURI());
    }

    @ExceptionHandler(NotFoundException.class)
    public ResponseEntity<Object> handleNotFound(NotFoundException exception, HttpServletRequest request) {
        return buildResponseEntity(exception.getMessage(), HttpStatus.NOT_FOUND.value(), request.getRequestURI());
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<Object> handleGeneric(Exception exception, HttpServletRequest request) {
        return buildResponseEntity("Error inesperado: " + exception.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR.value(), request.getRequestURI());
    }

    private ResponseEntity<Object> buildResponseEntity(String message, int status, String path) {
        ApiError apiError = new ApiError(LocalDateTime.now(), message, path);
        return ResponseEntity.status(status).body(apiError);
    }
}

