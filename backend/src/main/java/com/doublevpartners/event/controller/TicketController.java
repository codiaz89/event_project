package com.doublevpartners.event.controller;

import com.doublevpartners.event.dto.TicketFilter;
import com.doublevpartners.event.dto.TicketRequest;
import com.doublevpartners.event.dto.TicketResponse;
import com.doublevpartners.event.entity.TicketStatus;
import com.doublevpartners.event.service.TicketService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/tickets")
@Tag(name = "Tickets", description = "Operaciones CRUD para gestión de tickets de eventos")
public class TicketController {

    private final TicketService ticketService;

    public TicketController(TicketService ticketService) {
        this.ticketService = ticketService;
    }

    @Operation(summary = "Crear ticket", description = "Crea un nuevo ticket de evento asociado a un usuario")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "201", description = "Ticket creado exitosamente",
            content = @Content(schema = @Schema(implementation = TicketResponse.class))),
        @ApiResponse(responseCode = "400", description = "Datos de entrada inválidos"),
        @ApiResponse(responseCode = "404", description = "Usuario no encontrado"),
        @ApiResponse(responseCode = "401", description = "No autorizado")
    })
    @PostMapping
    public ResponseEntity<TicketResponse> createTicket(@Valid @RequestBody TicketRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ticketService.createTicket(request));
    }

    @Operation(summary = "Actualizar ticket", description = "Actualiza la información de un ticket existente")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Ticket actualizado exitosamente",
            content = @Content(schema = @Schema(implementation = TicketResponse.class))),
        @ApiResponse(responseCode = "400", description = "Datos de entrada inválidos"),
        @ApiResponse(responseCode = "404", description = "Ticket o usuario no encontrado"),
        @ApiResponse(responseCode = "401", description = "No autorizado")
    })
    @PutMapping("/{ticketId}")
    public ResponseEntity<TicketResponse> updateTicket(
        @Parameter(description = "ID único del ticket", required = true, example = "123e4567-e89b-12d3-a456-426614174000")
        @PathVariable UUID ticketId,
        @Valid @RequestBody TicketRequest request) {
        return ResponseEntity.ok(ticketService.updateTicket(ticketId, request));
    }

    @Operation(summary = "Eliminar ticket", description = "Elimina un ticket del sistema")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "204", description = "Ticket eliminado exitosamente"),
        @ApiResponse(responseCode = "404", description = "Ticket no encontrado"),
        @ApiResponse(responseCode = "401", description = "No autorizado")
    })
    @DeleteMapping("/{ticketId}")
    public ResponseEntity<Void> deleteTicket(
        @Parameter(description = "ID único del ticket", required = true, example = "123e4567-e89b-12d3-a456-426614174000")
        @PathVariable UUID ticketId) {
        ticketService.deleteTicket(ticketId);
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "Obtener ticket por ID", description = "Obtiene la información detallada de un ticket específico")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Ticket encontrado",
            content = @Content(schema = @Schema(implementation = TicketResponse.class))),
        @ApiResponse(responseCode = "404", description = "Ticket no encontrado"),
        @ApiResponse(responseCode = "401", description = "No autorizado")
    })
    @GetMapping("/{ticketId}")
    public ResponseEntity<TicketResponse> getTicketById(
        @Parameter(description = "ID único del ticket", required = true, example = "123e4567-e89b-12d3-a456-426614174000")
        @PathVariable UUID ticketId) {
        return ResponseEntity.ok(ticketService.getTicketById(ticketId));
    }

    @Operation(summary = "Listar tickets paginados", description = "Obtiene una lista paginada de tickets con filtros opcionales por estatus y usuario")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Lista de tickets obtenida exitosamente"),
        @ApiResponse(responseCode = "401", description = "No autorizado")
    })
    @GetMapping
    public ResponseEntity<Page<TicketResponse>> getTickets(
        @Parameter(description = "Filtrar por estatus (ABIERTO/CERRADO)", example = "ABIERTO")
        @RequestParam(required = false) TicketStatus status,
        @Parameter(description = "Filtrar por ID de usuario", example = "123e4567-e89b-12d3-a456-426614174000")
        @RequestParam(required = false) UUID userId,
        @Parameter(description = "Número de página (base 0)", example = "0")
        @RequestParam(defaultValue = "0") int page,
        @Parameter(description = "Tamaño de página", example = "10")
        @RequestParam(defaultValue = "10") int size
    ) {
        Pageable pageable = PageRequest.of(page, size);
        TicketFilter filter = new TicketFilter(status, userId);
        return ResponseEntity.ok(ticketService.getTickets(filter, pageable));
    }

    @Operation(summary = "Obtener tickets por usuario", description = "Obtiene todos los tickets asociados a un usuario específico (resultado cacheado)")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Lista de tickets del usuario obtenida exitosamente"),
        @ApiResponse(responseCode = "404", description = "Usuario no encontrado"),
        @ApiResponse(responseCode = "401", description = "No autorizado")
    })
    @GetMapping("/user/{userId}")
    public ResponseEntity<List<TicketResponse>> getTicketsByUser(
        @Parameter(description = "ID único del usuario", required = true, example = "123e4567-e89b-12d3-a456-426614174000")
        @PathVariable UUID userId) {
        return ResponseEntity.ok(ticketService.getTicketsByUser(userId));
    }
}

