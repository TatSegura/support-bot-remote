-- Inserts de prueba para la base de datos SBR

-- Usuarios
INSERT INTO usuarios (nombre, apellido, email, password, rol) VALUES
('Tatiana', 'Segura', 'tati@example.com', '1234', 'usuario'),
('Carlos', 'Ramírez', 'carlos@example.com', '1234', 'tecnico'),
('Laura', 'Gómez', 'laura@example.com', '1234', 'admin');

-- Tickets
INSERT INTO tickets (id_usuario, descripcion, estado) VALUES
(1, 'Ticket de prueba creado desde la app', 'pendiente'),
(2, 'Problema de conexión a internet', 'en_proceso'),
(3, 'Error en aplicación de escritorio', 'resuelto');

