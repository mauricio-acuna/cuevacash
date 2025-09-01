-- CuevaCash User Service - Datos Iniciales
-- Inserta roles, permisos y usuario administrador por defecto

-- Insertar permisos del sistema
INSERT INTO permissions (id, name, description, resource, action) VALUES
-- Permisos de usuarios
(uuid_generate_v4(), 'users:read', 'Leer información de usuarios', 'users', 'read'),
(uuid_generate_v4(), 'users:create', 'Crear nuevos usuarios', 'users', 'create'),
(uuid_generate_v4(), 'users:update', 'Actualizar información de usuarios', 'users', 'update'),
(uuid_generate_v4(), 'users:delete', 'Eliminar usuarios', 'users', 'delete'),
(uuid_generate_v4(), 'users:manage', 'Gestión completa de usuarios', 'users', 'manage'),

-- Permisos de roles
(uuid_generate_v4(), 'roles:read', 'Leer roles del sistema', 'roles', 'read'),
(uuid_generate_v4(), 'roles:create', 'Crear nuevos roles', 'roles', 'create'),
(uuid_generate_v4(), 'roles:update', 'Actualizar roles existentes', 'roles', 'update'),
(uuid_generate_v4(), 'roles:delete', 'Eliminar roles', 'roles', 'delete'),

-- Permisos de préstamos
(uuid_generate_v4(), 'loans:read', 'Consultar préstamos', 'loans', 'read'),
(uuid_generate_v4(), 'loans:create', 'Crear solicitudes de préstamo', 'loans', 'create'),
(uuid_generate_v4(), 'loans:update', 'Actualizar información de préstamos', 'loans', 'update'),
(uuid_generate_v4(), 'loans:approve', 'Aprobar préstamos', 'loans', 'approve'),
(uuid_generate_v4(), 'loans:cancel', 'Cancelar préstamos', 'loans', 'cancel'),
(uuid_generate_v4(), 'loans:manage', 'Gestión completa de préstamos', 'loans', 'manage'),

-- Permisos de casa de cambio
(uuid_generate_v4(), 'exchange:read', 'Consultar operaciones de cambio', 'exchange', 'read'),
(uuid_generate_v4(), 'exchange:create', 'Crear operaciones de cambio', 'exchange', 'create'),
(uuid_generate_v4(), 'exchange:update', 'Actualizar operaciones de cambio', 'exchange', 'update'),
(uuid_generate_v4(), 'exchange:cancel', 'Cancelar operaciones de cambio', 'exchange', 'cancel'),
(uuid_generate_v4(), 'exchange:rates', 'Gestionar tipos de cambio', 'exchange', 'rates'),

-- Permisos de rutas
(uuid_generate_v4(), 'routes:read', 'Consultar rutas y operadores', 'routes', 'read'),
(uuid_generate_v4(), 'routes:create', 'Crear rutas', 'routes', 'create'),
(uuid_generate_v4(), 'routes:update', 'Actualizar rutas', 'routes', 'update'),
(uuid_generate_v4(), 'routes:assign', 'Asignar operadores a rutas', 'routes', 'assign'),
(uuid_generate_v4(), 'routes:track', 'Rastrear operadores en rutas', 'routes', 'track'),

-- Permisos de reportes
(uuid_generate_v4(), 'reports:read', 'Consultar reportes', 'reports', 'read'),
(uuid_generate_v4(), 'reports:create', 'Generar reportes', 'reports', 'create'),
(uuid_generate_v4(), 'reports:export', 'Exportar reportes', 'reports', 'export'),

-- Permisos de configuración
(uuid_generate_v4(), 'config:read', 'Consultar configuraciones', 'config', 'read'),
(uuid_generate_v4(), 'config:update', 'Actualizar configuraciones', 'config', 'update');

-- Insertar roles del sistema
INSERT INTO roles (id, name, description) VALUES
(uuid_generate_v4(), 'ADMIN', 'Administrador del sistema con acceso completo'),
(uuid_generate_v4(), 'GESTOR_CENTRAL', 'Gestor central que coordina operaciones'),
(uuid_generate_v4(), 'OPERADOR', 'Operador móvil que atiende clientes en campo'),
(uuid_generate_v4(), 'CLIENTE', 'Cliente del sistema que solicita servicios');

-- Asignar permisos a roles
-- Administrador: todos los permisos
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id 
FROM roles r, permissions p 
WHERE r.name = 'ADMIN';

-- Gestor Central: permisos operacionales
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id 
FROM roles r, permissions p 
WHERE r.name = 'GESTOR_CENTRAL' 
AND p.resource IN ('loans', 'exchange', 'routes', 'reports')
AND p.action IN ('read', 'create', 'update', 'approve', 'assign', 'track', 'rates');

-- Operador: permisos básicos para operaciones en campo
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id 
FROM roles r, permissions p 
WHERE r.name = 'OPERADOR' 
AND ((p.resource = 'exchange' AND p.action IN ('read', 'create'))
     OR (p.resource = 'routes' AND p.action IN ('read', 'track'))
     OR (p.resource = 'loans' AND p.action = 'read'));

-- Cliente: permisos mínimos para consulta
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id 
FROM roles r, permissions p 
WHERE r.name = 'CLIENTE' 
AND p.resource IN ('loans', 'exchange')
AND p.action = 'read';

-- Crear usuario administrador por defecto
INSERT INTO users (id, username, email, password, first_name, last_name, is_active, email_verified)
VALUES (
    uuid_generate_v4(),
    'admin',
    'admin@cuevacash.com.py',
    '$2a$10$rQP8J8VEjKAYGHwqcEgODeZZ5aykq0yGlQ.xJF8sXoM5wR6z8K/YG', -- password: admin123
    'Administrador',
    'Sistema',
    true,
    true
);

-- Asignar rol de administrador al usuario admin
INSERT INTO user_roles (user_id, role_id)
SELECT u.id, r.id 
FROM users u, roles r 
WHERE u.username = 'admin' AND r.name = 'ADMIN';
