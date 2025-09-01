# Documentación Técnica - CuevaCash

## Índice
1. [Arquitectura del Sistema](#arquitectura-del-sistema)
2. [Microservicios](#microservicios)
3. [Base de Datos](#base-de-datos)
4. [Seguridad](#seguridad)
5. [APIs](#apis)
6. [Configuración](#configuración)
7. [Deployment](#deployment)
8. [Monitoreo](#monitoreo)

## Arquitectura del Sistema

### Visión General
CuevaCash utiliza una arquitectura de microservicios basada en Spring Boot para el backend y Angular para el frontend. El sistema está diseñado para ser escalable, mantenible y seguro.

```
┌─────────────────┐    ┌──────────────────┐    ┌───────────────┐
│   Frontend      │    │   API Gateway    │    │   Backend     │
│   (Angular)     │◄──►│   (Nginx)        │◄──►│   Services    │
│                 │    │                  │    │ (Spring Boot) │
└─────────────────┘    └──────────────────┘    └───────────────┘
                                │                        │
                                ▼                        ▼
                       ┌─────────────────┐    ┌───────────────┐
                       │   Load Balancer │    │   Message     │
                       │                 │    │   Queue       │
                       └─────────────────┘    │   (RabbitMQ)  │
                                              └───────────────┘
                                                       │
                                                       ▼
                                              ┌───────────────┐
                                              │   Database    │
                                              │ (PostgreSQL)  │
                                              └───────────────┘
```

### Tecnologías Principales
- **Backend**: Spring Boot 3.x, Java 17
- **Frontend**: Angular 17, TypeScript 5.x
- **Base de Datos**: PostgreSQL 15
- **Cache**: Redis 7
- **Message Queue**: RabbitMQ
- **Contenedores**: Docker, Docker Compose
- **Monitoreo**: Prometheus, Grafana

## Microservicios

### 1. User Service (Puerto 8081)
**Responsabilidad**: Gestión de usuarios, autenticación y autorización

**Funcionalidades**:
- CRUD de usuarios
- Autenticación con JWT
- Gestión de roles y permisos
- Bloqueo de cuentas por seguridad
- Verificación de email y teléfono

**Endpoints Principales**:
- `POST /api/v1/auth/login` - Iniciar sesión
- `POST /api/v1/auth/register` - Registrar usuario
- `GET /api/v1/users` - Listar usuarios
- `POST /api/v1/users` - Crear usuario
- `PUT /api/v1/users/{id}` - Actualizar usuario

### 2. Loan Service (Puerto 8082)
**Responsabilidad**: Gestión completa de préstamos

**Funcionalidades**:
- Solicitudes de préstamo
- Evaluación crediticia
- Cronogramas de pago
- Seguimiento de pagos
- Gestión de mora

### 3. Exchange Service (Puerto 8083)
**Responsabilidad**: Casa de cambio y gestión de divisas

**Funcionalidades**:
- Operaciones de cambio
- Cotizaciones en tiempo real
- Gestión de inventario
- Márgenes y comisiones
- Integración con APIs externas

### 4. Route Service (Porto 8084)
**Responsabilidad**: Gestión de rutas y operadores móviles

**Funcionalidades**:
- Gestión de rutas
- Asignación de operadores
- Tracking GPS
- Optimización de recorridos
- Métricas de performance

## Base de Datos

### Esquema de User Service

#### Tabla `users`
```sql
CREATE TABLE users (
    id UUID PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    document_number VARCHAR(20),
    document_type VARCHAR(20),
    phone VARCHAR(20),
    is_active BOOLEAN DEFAULT true,
    email_verified BOOLEAN DEFAULT false,
    phone_verified BOOLEAN DEFAULT false,
    last_login TIMESTAMP,
    failed_login_attempts INTEGER DEFAULT 0,
    account_locked_until TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### Tabla `roles`
```sql
CREATE TABLE roles (
    id UUID PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    description VARCHAR(255),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### Tabla `permissions`
```sql
CREATE TABLE permissions (
    id UUID PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description VARCHAR(255),
    resource VARCHAR(50) NOT NULL,
    action VARCHAR(50) NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Migraciones
Las migraciones se manejan con Flyway y se ejecutan automáticamente al iniciar cada microservicio.

Ubicación: `src/main/resources/db/migration/`

## Seguridad

### Autenticación
- **JWT (JSON Web Tokens)** para autenticación stateless
- **Refresh Tokens** para renovación segura de sesiones
- **Multi-factor Authentication** para operaciones críticas

### Autorización
- **Role-Based Access Control (RBAC)**
- **Permisos granulares** por recurso y acción
- **Spring Security** para control de acceso

### Roles del Sistema
1. **ADMIN**: Acceso completo al sistema
2. **GESTOR_CENTRAL**: Coordinación de operaciones
3. **OPERADOR**: Operaciones en campo
4. **CLIENTE**: Acceso básico para consultas

### Seguridad de Datos
- **Cifrado de contraseñas** con bcrypt
- **Cifrado en tránsito** con TLS 1.3
- **Cifrado en reposo** para datos sensibles
- **Auditoría completa** de operaciones

## APIs

### Estándares
- **REST** para comunicación sincrónica
- **OpenAPI/Swagger** para documentación
- **JSON** como formato de intercambio
- **HTTP Status Codes** estándar

### Documentación
Cada microservicio expone su documentación en:
- Swagger UI: `http://localhost:808X/api/v1/swagger-ui.html`
- OpenAPI JSON: `http://localhost:808X/api/v1/v3/api-docs`

### Rate Limiting
- **10 requests/segundo** por IP en el API Gateway
- **Burst de 20 requests** permitido
- **Blacklist automática** para IPs abusivas

## Configuración

### Variables de Entorno

#### User Service
```env
# Database
DATABASE_URL=jdbc:postgresql://localhost:5432/cuevacash_users
DATABASE_USERNAME=cuevacash
DATABASE_PASSWORD=cuevacash123

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=redis123

# RabbitMQ
RABBITMQ_HOST=localhost
RABBITMQ_PORT=5672
RABBITMQ_USERNAME=cuevacash
RABBITMQ_PASSWORD=rabbitmq123

# JWT
JWT_SECRET=your-secret-key
JWT_EXPIRATION=86400000
```

### Perfiles de Spring
- **default**: Desarrollo local
- **docker**: Contenedores Docker
- **staging**: Ambiente de pruebas
- **production**: Ambiente de producción

## Deployment

### Docker
Cada microservicio incluye un `Dockerfile` optimizado con:
- **Multi-stage builds** para reducir tamaño
- **Non-root user** para seguridad
- **Health checks** integrados
- **Layer caching** para builds rápidos

### Docker Compose
Para desarrollo local:
```bash
docker-compose up -d
```

### CI/CD con GitHub Actions
Pipeline automatizado que incluye:
1. **Testing** automatizado
2. **Security scanning**
3. **Building** de imágenes Docker
4. **Deployment** a staging y producción

### Kubernetes (Futuro)
Preparado para deployment en Kubernetes con:
- **Helm charts**
- **Auto-scaling**
- **Service mesh** con Istio
- **Monitoring** integrado

## Monitoreo

### Métricas
- **Prometheus** para recolección de métricas
- **Grafana** para visualización
- **Spring Boot Actuator** para health checks

### Logging
- **Structured logging** con JSON
- **Correlation IDs** para tracing
- **ELK Stack** para agregación (futuro)

### Alertas
- **Uptime monitoring**
- **Performance thresholds**
- **Error rate monitoring**
- **Capacity planning**

### Dashboards
Métricas clave monitoreadas:
- Response time
- Error rate
- Throughput
- Database connections
- Memory usage
- CPU usage

## Enlaces Útiles

### Desarrollo
- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Angular Documentation](https://angular.io/docs)
- [Docker Documentation](https://docs.docker.com/)

### APIs Externas
- [Alpha Vantage](https://www.alphavantage.co/documentation/)
- [Twilio SMS](https://www.twilio.com/docs/sms)
- [SendGrid Email](https://docs.sendgrid.com/)

### Herramientas
- [GitHub Actions](https://docs.github.com/en/actions)
- [Prometheus](https://prometheus.io/docs/)
- [Grafana](https://grafana.com/docs/)

---

**Última actualización**: Septiembre 2025  
**Versión**: 1.0.0  
**Mantenido por**: CuevaCash Development Team
