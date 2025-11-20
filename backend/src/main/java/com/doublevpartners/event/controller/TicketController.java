package com.doublevpartners.event.controller;

import com.doublevpartners.event.dto.TicketFilter;
import com.doublevpartners.event.dto.TicketRequest;
import com.doublevpartners.event.dto.TicketResponse;
import com.doublevpartners.event.entity.TicketStatus;
import com.doublevpartners.event.service.TicketService;
import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
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
public class TicketController {

    private final TicketService ticketService;

    public TicketController(TicketService ticketService) {
        this.ticketService = ticketService;
    }

    @PostMapping
    public ResponseEntity<TicketResponse> createTicket(@Valid @RequestBody TicketRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ticketService.createTicket(request));
    }

    @PutMapping("/{ticketId}")
    public ResponseEntity<TicketResponse> updateTicket(@PathVariable UUID ticketId, @Valid @RequestBody TicketRequest request) {
        return ResponseEntity.ok(ticketService.updateTicket(ticketId, request));
    }

    @GetMapping("/{ticketId}")
    public ResponseEntity<TicketResponse> getTicketById(@PathVariable UUID ticketId) {
        return ResponseEntity.ok(ticketService.getTicketById(ticketId));
    }

    @GetMapping
    public ResponseEntity<Page<TicketResponse>> getTickets(
        @RequestParam(required = false) TicketStatus status,
        @RequestParam(required = false) UUID userId,
        @RequestParam(defaultValue = "0") int page,
        @RequestParam(defaultValue = "10") int size
    ) {
        Pageable pageable = PageRequest.of(page, size);
        TicketFilter filter = new TicketFilter(status, userId);
        return ResponseEntity.ok(ticketService.getTickets(filter, pageable));
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<TicketResponse>> getTicketsByUser(@PathVariable UUID userId) {
        return ResponseEntity.ok(ticketService.getTicketsByUser(userId));
    }
}

