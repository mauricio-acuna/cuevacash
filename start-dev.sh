#!/bin/bash

# CuevaCash Development Quick Start Script
# Este script configura y inicia todos los servicios necesarios para desarrollo

set -e

echo "🏦 CuevaCash - Quick Start Script"
echo "================================="

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para mostrar mensajes
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar prerrequisitos
check_prerequisites() {
    log_info "Verificando prerrequisitos..."
    
    # Verificar Docker
    if ! command -v docker &> /dev/null; then
        log_error "Docker no está instalado. Por favor instalar Docker."
        exit 1
    fi
    
    # Verificar Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        log_error "Docker Compose no está instalado. Por favor instalar Docker Compose."
        exit 1
    fi
    
    # Verificar Java 17
    if ! command -v java &> /dev/null; then
        log_warning "Java no está instalado. Se necesita Java 17+ para desarrollo local."
    else
        JAVA_VERSION=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2)
        log_info "Java version: $JAVA_VERSION"
    fi
    
    # Verificar Node.js
    if ! command -v node &> /dev/null; then
        log_warning "Node.js no está instalado. Se necesita Node.js 18+ para el frontend."
    else
        NODE_VERSION=$(node --version)
        log_info "Node.js version: $NODE_VERSION"
    fi
    
    log_success "Verificación de prerrequisitos completada"
}

# Iniciar servicios de infraestructura
start_infrastructure() {
    log_info "Iniciando servicios de infraestructura..."
    
    # Crear red si no existe
    docker network create cuevacash-network 2>/dev/null || true
    
    # Iniciar PostgreSQL, Redis, RabbitMQ
    docker-compose up -d postgres redis rabbitmq
    
    log_info "Esperando que los servicios estén listos..."
    sleep 30
    
    # Verificar que PostgreSQL esté listo
    until docker-compose exec postgres pg_isready -U cuevacash; do
        log_info "Esperando PostgreSQL..."
        sleep 5
    done
    
    # Verificar que Redis esté listo
    until docker-compose exec redis redis-cli ping; do
        log_info "Esperando Redis..."
        sleep 5
    done
    
    log_success "Servicios de infraestructura iniciados correctamente"
}

# Compilar servicios backend
build_backend() {
    log_info "Compilando servicios backend..."
    
    cd backend/user-service
    if [ -f "./mvnw" ]; then
        ./mvnw clean compile
    else
        mvn clean compile
    fi
    cd ../..
    
    log_success "Backend compilado correctamente"
}

# Ejecutar migraciones de base de datos
run_migrations() {
    log_info "Ejecutando migraciones de base de datos..."
    
    cd backend/user-service
    if [ -f "./mvnw" ]; then
        ./mvnw flyway:migrate
    else
        mvn flyway:migrate
    fi
    cd ../..
    
    log_success "Migraciones ejecutadas correctamente"
}

# Iniciar servicios backend
start_backend() {
    log_info "Iniciando servicios backend..."
    
    # Iniciar user-service
    cd backend/user-service
    if [ -f "./mvnw" ]; then
        ./mvnw spring-boot:run &
    else
        mvn spring-boot:run &
    fi
    cd ../..
    
    USER_SERVICE_PID=$!
    echo $USER_SERVICE_PID > .user-service.pid
    
    log_success "User Service iniciado (PID: $USER_SERVICE_PID)"
}

# Verificar que los servicios estén funcionando
verify_services() {
    log_info "Verificando servicios..."
    
    # Esperar un poco para que los servicios inicien
    sleep 30
    
    # Verificar User Service
    if curl -f http://localhost:8081/api/v1/actuator/health &> /dev/null; then
        log_success "User Service está funcionando correctamente"
    else
        log_warning "User Service no responde. Verificar logs."
    fi
    
    # Mostrar URLs útiles
    echo ""
    log_info "🚀 Servicios disponibles:"
    echo "  - User Service API: http://localhost:8081/api/v1"
    echo "  - User Service Swagger: http://localhost:8081/api/v1/swagger-ui.html"
    echo "  - PostgreSQL: localhost:5432"
    echo "  - Redis: localhost:6379"
    echo "  - RabbitMQ Management: http://localhost:15672 (user: cuevacash, pass: rabbitmq123)"
    echo ""
}

# Función para limpiar procesos al salir
cleanup() {
    log_info "Deteniendo servicios..."
    
    # Detener backend services
    if [ -f .user-service.pid ]; then
        USER_SERVICE_PID=$(cat .user-service.pid)
        kill $USER_SERVICE_PID 2>/dev/null || true
        rm .user-service.pid
    fi
    
    # Detener Docker containers
    docker-compose down
    
    log_success "Servicios detenidos"
}

# Configurar trap para cleanup
trap cleanup EXIT

# Función principal
main() {
    case "${1:-start}" in
        start)
            check_prerequisites
            start_infrastructure
            run_migrations
            build_backend
            start_backend
            verify_services
            
            log_success "🎉 CuevaCash iniciado correctamente!"
            log_info "Presiona Ctrl+C para detener todos los servicios"
            
            # Mantener el script corriendo
            wait
            ;;
        stop)
            cleanup
            ;;
        restart)
            cleanup
            sleep 5
            $0 start
            ;;
        *)
            echo "Uso: $0 {start|stop|restart}"
            echo "  start   - Inicia todos los servicios (default)"
            echo "  stop    - Detiene todos los servicios"
            echo "  restart - Reinicia todos los servicios"
            exit 1
            ;;
    esac
}

# Ejecutar función principal
main "$@"
