package com.doublevpartners.event.repository;

import com.doublevpartners.event.entity.TicketEntity;
import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface TicketRepository extends JpaRepository<TicketEntity, UUID>, JpaSpecificationExecutor<TicketEntity> {

    List<TicketEntity> findByUserId(UUID userId);
}

