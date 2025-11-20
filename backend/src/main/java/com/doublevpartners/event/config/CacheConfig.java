package com.doublevpartners.event.config;

import org.springframework.cache.CacheManager;
import org.springframework.cache.concurrent.ConcurrentMapCacheManager;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class CacheConfig {

    public static final String USER_TICKETS_CACHE = "userTickets";

    @Bean
    public CacheManager cacheManager() {
        return new ConcurrentMapCacheManager(USER_TICKETS_CACHE);
    }
}

