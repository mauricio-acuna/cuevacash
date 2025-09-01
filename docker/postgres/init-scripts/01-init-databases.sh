#!/bin/bash
set -e

# Script para crear múltiples bases de datos en PostgreSQL
# Utilizado por Docker para inicializar las BDs de los microservicios

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    -- Database para User Service
    CREATE DATABASE cuevacash_users;
    GRANT ALL PRIVILEGES ON DATABASE cuevacash_users TO cuevacash;

    -- Database para Loan Service
    CREATE DATABASE cuevacash_loans;
    GRANT ALL PRIVILEGES ON DATABASE cuevacash_loans TO cuevacash;

    -- Database para Exchange Service
    CREATE DATABASE cuevacash_exchange;
    GRANT ALL PRIVILEGES ON DATABASE cuevacash_exchange TO cuevacash;

    -- Database para Route Service
    CREATE DATABASE cuevacash_routes;
    GRANT ALL PRIVILEGES ON DATABASE cuevacash_routes TO cuevacash;

    -- Database para Notification Service
    CREATE DATABASE cuevacash_notifications;
    GRANT ALL PRIVILEGES ON DATABASE cuevacash_notifications TO cuevacash;

    -- Database para Report Service
    CREATE DATABASE cuevacash_reports;
    GRANT ALL PRIVILEGES ON DATABASE cuevacash_reports TO cuevacash;
EOSQL

echo "Databases created successfully!"

# Conectar a cada database y crear extensiones necesarias
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "cuevacash_users" <<-EOSQL
    CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
    CREATE EXTENSION IF NOT EXISTS "pgcrypto";
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "cuevacash_loans" <<-EOSQL
    CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
    CREATE EXTENSION IF NOT EXISTS "pgcrypto";
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "cuevacash_exchange" <<-EOSQL
    CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
    CREATE EXTENSION IF NOT EXISTS "pgcrypto";
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "cuevacash_routes" <<-EOSQL
    CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
    CREATE EXTENSION IF NOT EXISTS "pgcrypto";
    CREATE EXTENSION IF NOT EXISTS "postgis";
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "cuevacash_notifications" <<-EOSQL
    CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
    CREATE EXTENSION IF NOT EXISTS "pgcrypto";
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "cuevacash_reports" <<-EOSQL
    CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
    CREATE EXTENSION IF NOT EXISTS "pgcrypto";
EOSQL

echo "Extensions created successfully!"
