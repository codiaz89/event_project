package com.doublevpartners.event.service;

import static org.assertj.core.api.Assertions.assertThat;

import com.doublevpartners.event.dto.TicketFilter;
import com.doublevpartners.event.dto.TicketRequest;
import com.doublevpartners.event.dto.TicketResponse;
import com.doublevpartners.event.dto.UserRequest;
import com.doublevpartners.event.dto.UserResponse;
import com.doublevpartners.event.entity.TicketStatus;
import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.test.context.ActiveProfiles;

@SpringBootTest
@ActiveProfiles("test")
class TicketServiceTest {

    @Autowired
    private TicketService ticketService;

    @Autowired
    private UserService userService;

    private UserResponse user;

    @BeforeEach
    void setUp() {
        user = userService.createUser(new UserRequest("Ana", "López"));
    }

    @Test
    void shouldCreateTicketsAndFilterByStatus() {
        ticketService.createTicket(new TicketRequest("Soporte de acceso", user.id(), TicketStatus.ABIERTO));
        ticketService.createTicket(new TicketRequest("Problema cerrado", user.id(), TicketStatus.CERRADO));

        TicketFilter filter = new TicketFilter(TicketStatus.ABIERTO, null);
        Page<TicketResponse> responsePage = ticketService.getTickets(filter, PageRequest.of(0, 10));

        assertThat(responsePage.getTotalElements()).isEqualTo(1);
        assertThat(responsePage.getContent().get(0).status()).isEqualTo(TicketStatus.ABIERTO);
    }

    @Test
    void shouldCacheTicketsByUser() {
        ticketService.createTicket(new TicketRequest("Validar cache", user.id(), TicketStatus.ABIERTO));
        List<TicketResponse> firstCall = ticketService.getTicketsByUser(user.id());
        List<TicketResponse> secondCall = ticketService.getTicketsByUser(user.id());

        assertThat(firstCall).hasSize(1);
        assertThat(secondCall).hasSize(1);
        assertThat(secondCall.get(0).description()).isEqualTo(firstCall.get(0).description());
    }
}

