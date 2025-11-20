package com.doublevpartners.event.service.impl;

import static com.doublevpartners.event.config.CacheConfig.USER_TICKETS_CACHE;

import com.doublevpartners.event.dto.TicketFilter;
import com.doublevpartners.event.dto.TicketRequest;
import com.doublevpartners.event.dto.TicketResponse;
import com.doublevpartners.event.entity.TicketEntity;
import com.doublevpartners.event.entity.UserEntity;
import com.doublevpartners.event.exception.NotFoundException;
import com.doublevpartners.event.mapper.TicketMapper;
import com.doublevpartners.event.repository.TicketRepository;
import com.doublevpartners.event.repository.UserRepository;
import com.doublevpartners.event.service.TicketService;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class TicketServiceImpl implements TicketService {

    private final TicketRepository ticketRepository;
    private final UserRepository userRepository;
    private final TicketMapper ticketMapper;
    private final CacheManager cacheManager;

    public TicketServiceImpl(
        TicketRepository ticketRepository,
        UserRepository userRepository,
        TicketMapper ticketMapper,
        CacheManager cacheManager
    ) {
        this.ticketRepository = ticketRepository;
        this.userRepository = userRepository;
        this.ticketMapper = ticketMapper;
        this.cacheManager = cacheManager;
    }

    @Override
    public TicketResponse createTicket(TicketRequest request) {
        UserEntity user = getUser(request.userId());
        TicketEntity entity = ticketMapper.toEntity(request, user);
        TicketResponse response = ticketMapper.toResponse(ticketRepository.save(entity));
        evictUserTicketsCache(user.getId());
        return response;
    }

    @Override
    public TicketResponse updateTicket(UUID ticketId, TicketRequest request) {
        TicketEntity entity = getTicket(ticketId);
        UUID previousUserId = entity.getUser().getId();
        UserEntity user = getUser(request.userId());
        ticketMapper.updateEntity(entity, request, user);
        TicketResponse response = ticketMapper.toResponse(ticketRepository.save(entity));
        evictUserTicketsCache(previousUserId);
        evictUserTicketsCache(user.getId());
        return response;
    }

    @Override
    @Transactional(readOnly = true)
    public TicketResponse getTicketById(UUID ticketId) {
        return ticketMapper.toResponse(getTicket(ticketId));
    }

    @Override
    @Transactional(readOnly = true)
    public Page<TicketResponse> getTickets(TicketFilter filter, Pageable pageable) {
        Specification<TicketEntity> specification = Specification.where(null);

        if (filter != null) {
            if (filter.hasStatus()) {
                specification = specification.and((root, query, builder) -> builder.equal(root.get("status"), filter.status()));
            }
            if (filter.hasUser()) {
                specification = specification.and((root, query, builder) -> builder.equal(root.get("user").get("id"), filter.userId()));
            }
        }

        return ticketRepository.findAll(specification, pageable)
            .map(ticketMapper::toResponse);
    }

    @Override
    @Transactional(readOnly = true)
    @Cacheable(value = USER_TICKETS_CACHE, key = "#userId")
    public List<TicketResponse> getTicketsByUser(UUID userId) {
        return ticketRepository.findByUserId(userId)
            .stream()
            .map(ticketMapper::toResponse)
            .collect(Collectors.toList());
    }

    private UserEntity getUser(UUID userId) {
        return userRepository.findById(userId)
            .orElseThrow(() -> new NotFoundException("Usuario no encontrado con id " + userId));
    }

    private TicketEntity getTicket(UUID ticketId) {
        return ticketRepository.findById(ticketId)
            .orElseThrow(() -> new NotFoundException("Ticket no encontrado con id " + ticketId));
    }

    private void evictUserTicketsCache(UUID userId) {
        if (userId == null || cacheManager.getCache(USER_TICKETS_CACHE) == null) {
            return;
        }
        cacheManager.getCache(USER_TICKETS_CACHE).evict(userId);
    }
}

