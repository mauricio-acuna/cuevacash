# CuevaCash - Sistema Financiero Integral

## 🏦 Descripción
CuevaCash es una plataforma financiera integral que combina servicios de préstamos y casa de cambio, diseñada específicamente para atender las necesidades del mercado financiero regional con operadores móviles.

## 🚀 Características Principales

### 💰 Gestión de Préstamos
- Préstamos en USD y PYG (Guaraníes)
- Modalidades: Pagadiario, Semanal, Mensual
- Montos: Pequeños (USD 100-1,000) y Medianos (USD 1,001-10,000)
- Sistema de evaluación crediticia
- Cronogramas de pago automatizados

### 💱 Casa de Cambio
- Múltiples divisas: PYG, USD, EUR, BRL
- Cotizaciones en tiempo real
- Gestión de márgenes y comisiones
- Control de inventario por divisa
- Futuro soporte para criptomonedas

### 🗺️ Gestión de Operadores Móviles
- Red de operadores que atienden clientes en ubicación
- Tracking GPS en tiempo real
- Optimización de rutas
- Gestión centralizada desde casa matriz

### 🌐 Portal Público
- Website institucional
- Información de servicios
- Formularios de contacto
- Blog y noticias del sector

## 🏗️ Arquitectura Técnica

### Backend
- **Framework:** Spring Boot 3.x
- **Lenguaje:** Java 17 LTS
- **Base de Datos:** PostgreSQL 15
- **Cache:** Redis 7
- **Message Queue:** RabbitMQ
- **Seguridad:** Spring Security + JWT

### Frontend
- **Framework:** Angular 17
- **Lenguaje:** TypeScript 5.x
- **UI Library:** Angular Material
- **State Management:** NgRx

### Mobile
- **Framework:** Flutter
- **Lenguaje:** Dart

### DevOps
- **Contenedores:** Docker + Docker Compose
- **CI/CD:** GitHub Actions
- **Monitoreo:** Prometheus + Grafana
- **Cloud:** AWS

## 📁 Estructura del Proyecto

```
cuevacash/
├── backend/                 # Aplicación Spring Boot
│   ├── user-service/        # Microservicio de usuarios
│   ├── loan-service/        # Microservicio de préstamos
│   ├── exchange-service/    # Microservicio casa de cambio
│   ├── route-service/       # Microservicio de rutas
│   ├── notification-service/ # Microservicio de notificaciones
│   └── report-service/      # Microservicio de reportes
├── frontend/                # Aplicación Angular (Admin Panel)
├── mobile/                  # Aplicación Flutter (Operadores)
├── docs/                    # Documentación del proyecto
├── docker/                  # Configuraciones Docker
└── .github/workflows/       # GitHub Actions CI/CD
```

## 🚀 Inicio Rápido

### Prerrequisitos
- Java 17+
- Node.js 18+
- Docker & Docker Compose
- PostgreSQL 15
- Redis 7

### Instalación

1. **Clonar el repositorio**
```bash
git clone https://github.com/mauricio-acuna/cuevacash.git
cd cuevacash
```

2. **Levantar servicios con Docker**
```bash
docker-compose up -d postgres redis rabbitmq
```

3. **Backend (Spring Boot)**
```bash
cd backend
./mvnw spring-boot:run
```

4. **Frontend (Angular)**
```bash
cd frontend
npm install
ng serve
```

5. **Mobile (Flutter)**
```bash
cd mobile
flutter pub get
flutter run
```

## 📊 Estado del Proyecto

### ✅ Completado
- [x] PRD (Product Requirements Document)
- [x] Estructura inicial del proyecto
- [x] Configuración de repositorio Git

### 🔄 En Desarrollo
- [ ] Configuración de infraestructura base
- [ ] Setup de microservicios
- [ ] Sistema de autenticación
- [ ] Base de datos y modelos

### 📋 Planificado
- [ ] Módulo de préstamos
- [ ] Casa de cambio MVP
- [ ] Gestión de operadores
- [ ] Portal público
- [ ] Integraciones externas

## 📈 Roadmap

### Fase 1: Fundación (Meses 1-3)
- Setup e infraestructura
- Autenticación y usuarios
- Base de datos y modelos

### Fase 2: Funcionalidades Core (Meses 4-6)
- Módulo de préstamos
- Casa de cambio MVP
- Gestión de operadores

### Fase 3: Optimización (Meses 7-9)
- Portal público
- Reportería avanzada
- Optimizaciones de performance

### Fase 4: Features Avanzadas (Meses 10-12)
- Integraciones bancarias
- Features premium con ML
- Preparación para producción

## 👥 Equipo de Desarrollo

- **Product Owner:** Definición de requerimientos y prioridades
- **Scrum Master:** Facilitación de metodología ágil
- **Backend Developers:** Desarrollo de microservicios
- **Frontend Developers:** Desarrollo de interfaces web
- **Mobile Developer:** Desarrollo de app móvil
- **DevOps Engineer:** Infraestructura y CI/CD
- **QA Engineer:** Testing y calidad
- **UI/UX Designer:** Diseño de interfaces

## 📞 Contacto

Para consultas sobre el proyecto:
- **Email:** desarrollo@cuevacash.com.py
- **GitHub:** https://github.com/mauricio-acuna/cuevacash

## 📄 Licencia

Este proyecto es propietario de CuevaCash. Todos los derechos reservados.

---

**Versión:** 1.0.0  
**Última actualización:** Septiembre 2025
