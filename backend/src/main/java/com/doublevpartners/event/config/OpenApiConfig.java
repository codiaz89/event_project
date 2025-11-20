package com.doublevpartners.event.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.servers.Server;
import java.util.List;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI eventPlatformOpenAPI() {
        Server localServer = new Server();
        localServer.setUrl("http://localhost:8080");
        localServer.setDescription("Servidor local de desarrollo");

        Contact contact = new Contact();
        contact.setEmail("welcome@doublevpartners.com");
        contact.setName("Double V Partners / NYX");

        License license = new License()
            .name("MIT License")
            .url("https://opensource.org/licenses/MIT");

        Info info = new Info()
            .title("Event Platform API")
            .version("1.0.0")
            .contact(contact)
            .description("API REST para gestión de usuarios y tickets de eventos. " +
                "Proporciona operaciones CRUD completas con soporte para filtrado y paginación.")
            .license(license);

        return new OpenAPI()
            .info(info)
            .servers(List.of(localServer));
    }
}

