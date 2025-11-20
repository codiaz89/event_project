package com.doublevpartners.event.service;

import com.doublevpartners.event.dto.TicketFilter;
import com.doublevpartners.event.dto.TicketRequest;
import com.doublevpartners.event.dto.TicketResponse;
import java.util.List;
import java.util.UUID;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface TicketService {

    TicketResponse createTicket(TicketRequest request);

    TicketResponse updateTicket(UUID ticketId, TicketRequest request);

    TicketResponse getTicketById(UUID ticketId);

    Page<TicketResponse> getTickets(TicketFilter filter, Pageable pageable);

    List<TicketResponse> getTicketsByUser(UUID userId);

    void deleteTicket(UUID ticketId);
}

