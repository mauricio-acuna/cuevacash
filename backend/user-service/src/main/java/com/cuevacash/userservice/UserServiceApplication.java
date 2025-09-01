package com.cuevacash.userservice;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

/**
 * Aplicación principal del microservicio de usuarios de CuevaCash
 * 
 * Este microservicio se encarga de:
 * - Gestión de usuarios (CRUD)
 * - Autenticación y autorización
 * - Gestión de roles y permisos
 * - Generación de tokens JWT
 * 
 * @author CuevaCash Development Team
 * @version 1.0.0
 */
@SpringBootApplication
@EnableJpaAuditing
@EnableCaching
public class UserServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(UserServiceApplication.class, args);
    }
}
