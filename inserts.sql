-- Inserts para la tabla areas
INSERT INTO areas (id_area, nombre, fumadores) VALUES
('A01', 'Salón Principal', false),
('A02', 'Terraza', true),
('A03', 'Bar', true),
('A04', 'Área VIP', false),
('A05', 'Sala de Juegos', false),
('A06', 'Salón de Eventos', false),
('A07', 'Área de Fumadores', true),
('A08', 'Patio', true),
('A09', 'Zona de Lectura', false),
('A10', 'Sala de Espera', false);

-- Inserts para la tabla empleados
INSERT INTO empleados (id_empleado, nombre, rol, area) VALUES
('E001', 'Juan Perez', 'Mesero', 'A01'),
('E002', 'Maria Rodriguez', 'Cocinero', 'A01'),
('E003', 'Luis Martinez', 'Host', 'A01'),
('E004', 'Ana Garcia', 'Mesera', 'A07'),
('E005', 'Carlos Sanchez', 'Bartender', 'A03'),
('E006', 'Laura Diaz', 'Bartender', 'A01'),
('E007', 'Pedro Lopez', 'Cocinero', 'A04'),
('E008', 'Elena Castro', 'Mesera', 'A02'),
('E009', 'Diego Herrera', 'Cocinero', 'A01'),
('E010', 'Sofia Gómez', 'Mesera', 'A01');

-- Insert de contraseñas
UPDATE empleados
SET contrasena =
    CASE 
        WHEN id_empleado = 'E001' THEN crypt('111', gen_salt('bf'))
	    WHEN id_empleado = 'E002' THEN crypt('222', gen_salt('bf'))
	    WHEN id_empleado = 'E003' THEN crypt('333', gen_salt('bf'))
	    WHEN id_empleado = 'E004' THEN crypt('444', gen_salt('bf'))
	    WHEN id_empleado = 'E005' THEN crypt('555', gen_salt('bf'))
	    WHEN id_empleado = 'E006' THEN crypt('666', gen_salt('bf'))
	    WHEN id_empleado = 'E007' THEN crypt('777', gen_salt('bf'))
	    WHEN id_empleado = 'E008' THEN crypt('888', gen_salt('bf'))
	    WHEN id_empleado = 'E009' THEN crypt('999', gen_salt('bf'))
	    WHEN id_empleado = 'E010' THEN crypt('1010', gen_salt('bf'))
        ELSE NULL
    END

-- Inserts para la tabla menu
INSERT INTO menu (id_alimento, nombre, descripcion, precio) VALUES
('M001', 'Hamburguesa Clásica', 'Hamburguesa de carne de res con queso, lechuga y tomate.', 8.99),
('M002', 'Pizza Margarita', 'Pizza con salsa de tomate, mozzarella y albahaca fresca.', 10.50),
('M003', 'Ensalada César', 'Ensalada con lechuga romana, aderezo César, crutones y parmesano.', 7.75),
('M004', 'Pasta Alfredo', 'Pasta fetuccini con salsa Alfredo y pollo.', 12.25),
('M005', 'Sushi Variado', 'Combinación de sushi con rolls de salmón, atún y aguacate.', 15.99),
('M006', 'Pollo a la Parrilla', 'Pechuga de pollo a la parrilla con verduras asadas.', 11.75),
('M007', 'Sopa de Tomate', 'Sopa de tomate casera con crutones.', 6.50),
('M008', 'Tacos de Carnitas', 'Tacos de cerdo con cebolla, cilantro y salsa verde.', 9.25),
('M009', 'Paella Marinera', 'Paella valenciana con mariscos y arroz al azafrán.', 18.99),
('M010', 'Brownie con Helado', 'Brownie de chocolate caliente con helado de vainilla.', 5.99);

-- Inserts para la tabla mesas
INSERT INTO mesas (id_mesa, capacidad, movible, area) VALUES
('M001', 4, true, 'A01'),
('M002', 6, true, 'A01'),
('M003', 2, true, 'A02'),
('M004', 8, false, 'A03'),
('M005', 4, true, 'A04'),
('M006', 10, false, 'A01'),
('M007', 6, true, 'A02'),
('M008', 4, true, 'A01'),
('M009', 8, false, 'A05'),
('M010', 4, true, 'A06');

-- Inserts para la tabla mesas_juntas
INSERT INTO mesas_juntas (mesa_principal, mesa_adicional) VALUES
('M001', 'M002'),
('M003', 'M007'),
('M004', 'M008'),
('M005', 'M009'),
('M006', 'M010'),
('M002', 'M006'),
('M008', 'M010'),
('M003', 'M005'),
('M007', 'M009'),
('M001', 'M010');

-- Inserts para la tabla cuentas
INSERT INTO cuentas (id_cuenta, estado, tiempo_abierta, tiempo_carrada, mesa) VALUES
('C001', true, '2024-04-12 18:30:00', NULL, 'M001'),
('C002', false, '2024-04-12 19:15:00', '2024-04-12 19:35:00', 'M003'),
('C003', true, '2024-04-13 20:00:00', NULL, 'M006'),
('C004', false, '2024-04-13 20:45:00', '2024-04-13 21:45:00', 'M008'),
('C005', true, '2024-04-13 21:30:00', NULL, 'M010'),
('C006', false, '2024-04-13 22:15:00', '2024-04-13 22:30:00', 'M002'),
('C007', true, '2024-04-13 20:00:00', NULL, 'M004'),
('C008', false, '2024-04-14 15:30:00', '2024-04-14 16:35:00', 'M005'),
('C009', false, '2024-04-14 08:15:00', '2024-04-14 08:45:00', 'M007'),
('C010', true, '2024-04-15 10:00:00', NULL, 'M009');

-- Inserts para la tabla encuestas
INSERT INTO encuestas (id_encuesta, amabilidad, exactitud, cuenta, fecha) VALUES
('E001', 4, 5, 'C001', '2024-04-12'),
('E002', 3, 4, 'C002', '2024-04-12'),
('E003', 5, 3, 'C003', '2024-04-13'),
('E004', 2, 2, 'C004', '2024-04-13'),
('E005', 4, 5, 'C005', '2024-04-13'),
('E006', 5, 4, 'C006', '2024-04-13'),
('E007', 3, 3, 'C007', '2024-04-14'),
('E008', 2, 4, 'C008', '2024-04-14'),
('E009', 4, 5, 'C009', '2024-04-14'),
('E010', 5, 5, 'C010', '2024-04-15');

-- Inserts para la tabla quejas
INSERT INTO quejas (id_queja, nombre, fecha, motivo, gravedad, empleado, alimento) VALUES
('Q001', 'Ana', '2024-04-13', 'Servicio lento', 3, 'E001', NULL),
('Q002', 'Pedro', '2024-04-13', 'Comida fría', 4, 'E002', 'M001'),
('Q003', 'Luisa', '2024-04-13', 'Ruido excesivo', 2, 'E003', 'M001'),
('Q004', 'Carlos', '2024-04-13', 'Mesa sucia', 3, 'E001', NULL),
('Q005', 'Laura', '2024-04-13', 'Mal trato', 5, 'E005', 'M002'),
('Q006', 'Marta', '2024-04-13', 'Orden equivocada', 4, 'E006', 'M003'),
('Q007', 'Roberto', '2024-04-14', 'Demora en la atención', 3, 'E007', 'M003'),
('Q008', 'Elena', '2024-04-14', 'Falta de higiene', 2, 'E005', NULL),
('Q009', 'Diego', '2024-04-14', 'Alimento quemado', 4, 'E009', 'M006'),
('Q010', 'Sandra', '2024-04-14', 'Factura incorrecta', 3, 'E005', NULL);

-- Inserts para la tabla pedidos
INSERT INTO pedidos (cuenta, alimento, tiempo) VALUES
('C001', 'M001', '2024-04-12 18:35:00'),
('C002', 'M003', '2024-04-13 19:20:00'),
('C003', 'M006', '2024-04-13 20:05:00'),
('C004', 'M008', '2024-04-13 20:50:00'),
('C005', 'M010', '2024-04-15 21:35:00'),
('C006', 'M002', '2024-04-12 22:07:00'),
('C007', 'M004', '2024-04-13 20:05:00'),
('C008', 'M005', '2024-04-14 15:35:00'),
('C009', 'M007', '2024-04-14 08:20:00'),
('C010', 'M009', '2024-04-14 10:05:00'),
('C001', 'M006', '2024-04-12 19:00:00'),
('C003', 'M007', '2024-04-13 20:50:00');

-- Inserts para la tabla facturas
INSERT INTO facturas (id_factura, nit, nombre, direccion, monto, metodo_pago, fecha, cuenta) VALUES
('F001', '123456789', 'Ana Lopez', 'Calle 1, Ciudad', 20.74, 'Tarjeta de crédito', '2024-04-12', 'C001'),
('F002', '987654321', 'Luis Perez', 'Avenida 2, Ciudad', 7.75, 'Efectivo', '2024-04-12', 'C002'),
('F003', '456789123', 'Ramiro Ramirez', 'Carrera 3, Ciudad', 18.25, 'Tarjeta de débito', '2024-04-13', 'C003'),
('F004', '789123456', 'Lorenzo Lopez', 'Avenida 4, Ciudad', 9.25, 'Efectivo', '2024-04-13', 'C004'),
('F005', '321654987', 'Gian Carlo Medina', 'Calle 5, Ciudad', 5.99, 'Tarjeta de crédito', '2024-04-13', 'C005'),
('F006', '654987321', 'Jose Marchena', 'Carrera 6, Ciudad', 10.50, 'Efectivo', '2024-04-13', 'C006'),
('F007', '987321654', 'Nicolle Gordillo', 'Avenida 7, Ciudad', 12.25, 'Tarjeta de débito', '2024-04-14', 'C007'),
('F008', '321987654', 'Sofia Velasquez', 'Calle 8, Ciudad', 15.99, 'Efectivo', '2024-04-14', 'C008'),
('F009', '654321987', 'Marco Marquez', 'Carrera 9, Ciudad', 6.50, 'Tarjeta de crédito', '2024-04-14', 'C009'),
('F010', '123789456', 'Pedro Piedra', 'Avenida 10, Ciudad', 18.99, 'Efectivo', '2024-04-15', 'C010');

commit;