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

UPDATE cuentas
SET personas = 4 WHERE id_cuenta IN ('C001', 'C008');
UPDATE cuentas
SET personas = 3 WHERE id_cuenta IN ('C004','C005');
UPDATE cuentas
SET personas = 5 WHERE id_cuenta ='C006';
UPDATE cuentas
SET personas = 6 WHERE id_cuenta IN ('C009','C002');
UPDATE cuentas
SET personas = 8 WHERE id_cuenta IN ('C007','C003','C010');

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

UPDATE encuestas
SET empleado = 'E001' WHERE id_encuesta IN ('E001', 'E002');
UPDATE encuestas
SET empleado = 'E004' WHERE id_encuesta IN ('E003', 'E004', 'E005', 'E006');
UPDATE encuestas
SET empleado = 'E008' WHERE id_encuesta IN ('E007', 'E008', 'E009', 'E010');

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

--Añadir columna de tipo a la tabla de menu y agregar los tipos a los items del menú ya existentes
ALTER TABLE menu ADD COLUMN tipo VARCHAR(50);
UPDATE menu SET tipo = 'Plato Fuerte' WHERE id_alimento IN ('M001', 'M006', 'M008');
UPDATE menu SET tipo = 'Postre' WHERE id_alimento = 'M010';
UPDATE menu SET tipo = 'Entrada' WHERE id_alimento IN ('M003', 'M007');
UPDATE menu SET tipo = 'Plato Principal' WHERE id_alimento IN ('M002', 'M004', 'M009','M005');

--Agregar las bebidas al menu
INSERT INTO menu (id_alimento, nombre, descripcion, precio, tipo) VALUES
('M011', 'Coca Cola', 'Refresco de cola clásico.', 2.50, 'Bebida'),
('M012', 'Agua Mineral', 'Agua mineral natural.', 1.75, 'Bebida'),
('M013', 'Cerveza Artesanal', 'Cerveza rubia artesanal.', 3.50, 'Bebida'),
('M014', 'Jugo de Naranja Natural', 'Jugo recién exprimido de naranjas.', 2.99, 'Bebida'),
('M015', 'Café Americano', 'Café negro americano.', 1.99, 'Bebida');

--Agregar bebidas a los pedidos
INSERT INTO pedidos (cuenta, alimento, tiempo) VALUES
('C001', 'M011', '2024-04-12 18:40:00'),
('C002', 'M012', '2024-04-13 19:25:00'),
('C003', 'M013', '2024-04-13 20:10:00'),
('C004', 'M014', '2024-04-13 20:55:00'),
('C005', 'M015', '2024-04-15 21:40:00');

--Editar la tabla de facturas para que acepte montos de tarjeta y efectivo
ALTER TABLE facturas
DROP COLUMN monto,
DROP COLUMN metodo_pago;

ALTER TABLE facturas
ADD COLUMN monto_efectivo DOUBLE PRECISION,
ADD COLUMN monto_tarjeta DOUBLE PRECISION,
ADD COLUMN monto_total DOUBLE PRECISION;

--Llenar los datos de las 3 nuevas columnas de facturas
UPDATE facturas SET monto_efectivo = 5.05, monto_tarjeta = 2.70, monto_total = 7.75 WHERE id_factura = 'F002';
UPDATE facturas SET monto_efectivo = 4.40, monto_tarjeta = 13.85, monto_total = 18.25 WHERE id_factura = 'F003';
UPDATE facturas SET monto_efectivo = 3.30, monto_tarjeta = 5.95, monto_total = 9.25 WHERE id_factura = 'F004';
UPDATE facturas SET monto_efectivo = 2.62, monto_tarjeta = 3.37, monto_total = 5.99 WHERE id_factura = 'F005';
UPDATE facturas SET monto_efectivo = 5.74, monto_tarjeta = 4.76, monto_total = 10.50 WHERE id_factura = 'F006';
UPDATE facturas SET monto_efectivo = 4.08, monto_tarjeta = 8.17, monto_total = 12.25 WHERE id_factura = 'F007';
UPDATE facturas SET monto_efectivo = 15.98, monto_tarjeta = 0.01, monto_total = 15.99 WHERE id_factura = 'F008';
UPDATE facturas SET monto_efectivo = 6.49, monto_tarjeta = 0.01, monto_total = 6.50 WHERE id_factura = 'F009';
UPDATE facturas SET monto_efectivo = 7.76, monto_tarjeta = 11.23, monto_total = 18.99 WHERE id_factura = 'F010';

commit;