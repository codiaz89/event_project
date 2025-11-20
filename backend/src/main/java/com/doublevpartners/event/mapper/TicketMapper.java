package com.doublevpartners.event.mapper;

import com.doublevpartners.event.dto.TicketRequest;
import com.doublevpartners.event.dto.TicketResponse;
import com.doublevpartners.event.entity.TicketEntity;
import com.doublevpartners.event.entity.TicketStatus;
import com.doublevpartners.event.entity.UserEntity;
import org.springframework.stereotype.Component;

@Component
public class TicketMapper {

    public TicketEntity toEntity(TicketRequest request, UserEntity userEntity) {
        TicketEntity entity = new TicketEntity();
        entity.setDescription(request.description().trim());
        entity.setUser(userEntity);
        entity.setStatus(resolveStatus(request));
        return entity;
    }

    public void updateEntity(TicketEntity entity, TicketRequest request, UserEntity userEntity) {
        entity.setDescription(request.description().trim());
        entity.setUser(userEntity);
        entity.setStatus(resolveStatus(request));
    }

    public TicketResponse toResponse(TicketEntity entity) {
        return new TicketResponse(
            entity.getId(),
            entity.getDescription(),
            entity.getStatus(),
            entity.getUser().getId(),
            String.format("%s %s", entity.getUser().getFirstName(), entity.getUser().getLastName()).trim(),
            entity.getCreatedAt(),
            entity.getUpdatedAt()
        );
    }

    private TicketStatus resolveStatus(TicketRequest request) {
        return request.status() != null ? request.status() : TicketStatus.ABIERTO;
    }
}

