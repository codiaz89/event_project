package com.doublevpartners.event.controller;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.doublevpartners.event.security.JwtService;
import com.doublevpartners.event.service.UserService;
import com.doublevpartners.event.dto.UserRequest;
import com.doublevpartners.event.dto.UserResponse;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.Map;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class TicketControllerIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private JwtService jwtService;

    @Autowired
    private UserDetailsService userDetailsService;

    @Autowired
    private UserService userService;

    private String adminToken;
    private UUID userId;

    @BeforeEach
    void setUp() {
        UserDetails admin = userDetailsService.loadUserByUsername("admin");
        adminToken = jwtService.generateToken(admin);
        UserResponse user = userService.createUser(new UserRequest("Test", "User"));
        userId = user.id();
    }

    @Test
    void shouldCreateTicket() throws Exception {
        String requestBody = objectMapper.writeValueAsString(
            Map.of(
                "description", "Problema con acceso al sistema",
                "userId", userId.toString(),
                "status", "ABIERTO"
            )
        );

        mockMvc.perform(post("/api/tickets")
                .header("Authorization", "Bearer " + adminToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestBody))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.description").value("Problema con acceso al sistema"))
            .andExpect(jsonPath("$.status").value("ABIERTO"))
            .andExpect(jsonPath("$.id").exists());
    }

    @Test
    void shouldGetTicketsWithFilters() throws Exception {
        String createBody = objectMapper.writeValueAsString(
            Map.of(
                "description", "Ticket de prueba",
                "userId", userId.toString(),
                "status", "ABIERTO"
            )
        );

        mockMvc.perform(post("/api/tickets")
                .header("Authorization", "Bearer " + adminToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(createBody))
            .andExpect(status().isCreated());

        mockMvc.perform(get("/api/tickets")
                .header("Authorization", "Bearer " + adminToken)
                .param("status", "ABIERTO")
                .param("userId", userId.toString())
                .param("page", "0")
                .param("size", "10"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.content").isArray())
            .andExpect(jsonPath("$.totalElements").value(1));
    }

    @Test
    void shouldDeleteTicket() throws Exception {
        String createBody = objectMapper.writeValueAsString(
            Map.of(
                "description", "Ticket a eliminar",
                "userId", userId.toString(),
                "status", "ABIERTO"
            )
        );

        String createResponse = mockMvc.perform(post("/api/tickets")
                .header("Authorization", "Bearer " + adminToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(createBody))
            .andReturn()
            .getResponse()
            .getContentAsString();

        String ticketId = objectMapper.readTree(createResponse).get("id").asText();

        mockMvc.perform(delete("/api/tickets/" + ticketId)
                .header("Authorization", "Bearer " + adminToken))
            .andExpect(status().isNoContent());

        mockMvc.perform(get("/api/tickets/" + ticketId)
                .header("Authorization", "Bearer " + adminToken))
            .andExpect(status().isNotFound());
    }

    @Test
    void shouldGetTicketsByUser() throws Exception {
        String createBody = objectMapper.writeValueAsString(
            Map.of(
                "description", "Ticket del usuario",
                "userId", userId.toString(),
                "status", "ABIERTO"
            )
        );

        mockMvc.perform(post("/api/tickets")
                .header("Authorization", "Bearer " + adminToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(createBody))
            .andExpect(status().isCreated());

        mockMvc.perform(get("/api/tickets/user/" + userId)
                .header("Authorization", "Bearer " + adminToken))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$").isArray())
            .andExpect(jsonPath("$[0].description").value("Ticket del usuario"));
    }
}

