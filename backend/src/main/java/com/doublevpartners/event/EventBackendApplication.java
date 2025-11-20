package com.doublevpartners.event;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;

@SpringBootApplication
@EnableCaching
public class EventBackendApplication {

    public static void main(String[] args) {
        SpringApplication.run(EventBackendApplication.class, args);
    }
}