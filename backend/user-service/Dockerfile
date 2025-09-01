# Multi-stage Docker build para CuevaCash User Service
FROM eclipse-temurin:17-jdk-alpine AS builder

# Configurar directorio de trabajo
WORKDIR /app

# Copiar archivos de configuración de Maven
COPY pom.xml .
COPY mvnw .
COPY .mvn .mvn

# Descargar dependencias (se cachean en esta capa)
RUN ./mvnw dependency:go-offline -B

# Copiar código fuente
COPY src src

# Compilar la aplicación
RUN ./mvnw clean package -DskipTests

# Extraer layers del JAR para optimizar el cache de Docker
RUN java -Djarmode=layertools -jar target/*.jar extract

# Imagen final de producción
FROM eclipse-temurin:17-jre-alpine

# Instalar curl para health checks
RUN apk add --no-cache curl

# Crear usuario no-root para seguridad
RUN addgroup -g 1001 -S cuevacash && \
    adduser -S cuevacash -u 1001 -G cuevacash

# Configurar directorio de trabajo
WORKDIR /app

# Cambiar ownership del directorio
RUN chown -R cuevacash:cuevacash /app

# Cambiar al usuario no-root
USER cuevacash

# Copiar layers extraídos desde el builder
COPY --from=builder --chown=cuevacash:cuevacash app/dependencies/ ./
COPY --from=builder --chown=cuevacash:cuevacash app/spring-boot-loader/ ./
COPY --from=builder --chown=cuevacash:cuevacash app/snapshot-dependencies/ ./
COPY --from=builder --chown=cuevacash:cuevacash app/application/ ./

# Configurar variables de entorno
ENV JAVA_OPTS="-Xmx512m -Xms256m" \
    SPRING_PROFILES_ACTIVE=docker

# Exponer puerto
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/api/v1/actuator/health || exit 1

# Comando de inicio
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS org.springframework.boot.loader.JarLauncher"]

# Labels para metadata
LABEL maintainer="CuevaCash Development Team <desarrollo@cuevacash.com.py>" \
      version="1.0.0" \
      description="CuevaCash User Service - Microservicio de gestión de usuarios" \
      org.opencontainers.image.source="https://github.com/mauricio-acuna/cuevacash"
