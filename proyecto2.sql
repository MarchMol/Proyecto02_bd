-- TABLAS Y LLAVES --

BEGIN;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Areas
CREATE TABLE areas(
    id_area VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(50),
    fumadores BOOLEAN
);
-- \Areas

-- Empleados
CREATE TABLE empleados(
    id_empleado VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(50),
    rol VARCHAR(50),
    area VARCHAR(10) NULL, --FK
    contrasena CHAR(60)
);
ALTER TABLE empleados
ADD CONSTRAINT fk_areas_empleados
FOREIGN KEY (area)
REFERENCES areas(id_area);
-- \Empleados

-- Menu
CREATE TABLE menu(
    id_alimento VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(50),
    descripcion TEXT,
    precio DOUBLE PRECISION
);
--\Menu

-- Mesas
CREATE TABLE mesas(
    id_mesa VARCHAR(10) PRIMARY KEY,
    capacidad INT,
    movible BOOLEAN,
    area VARCHAR(10) --FK
);

ALTER TABLE mesas
ADD CONSTRAINT fk_areas_mesas
FOREIGN KEY (area)
REFERENCES areas(id_area);
-- \Mesas


-- TABLA INTERMEDIA: mesas juntas
CREATE TABLE mesas_juntas(
    mesa_principal VARCHAR(10), --FK
    mesa_adicional VARCHAR(10) --FK
);

ALTER TABLE mesas_juntas
ADD CONSTRAINT fk_mesa_principal
FOREIGN KEY (mesa_principal)
REFERENCES mesas(id_mesa),
ADD CONSTRAINT fk_mesa_adicional
FOREIGN KEY (mesa_adicional)
REFERENCES mesas(id_mesa);
-- \mesas juntas

-- Cuentas
CREATE TABLE cuentas(
    id_cuenta VARCHAR(10) PRIMARY KEY,
    estado BOOLEAN,
    tiempo_abierta TIMESTAMP,
    tiempo_carrada TIMESTAMP,
    mesa VARCHAR(10) --FK
);
ALTER TABLE cuentas
ADD CONSTRAINT fk_cuenta_mesa
FOREIGN KEY (mesa)
REFERENCES mesas(id_mesa);

Alter table cuentas
Add personas INT;

-- \Cuentas

-- Encuesta
CREATE TABLE encuestas(
    id_encuesta VARCHAR(10) PRIMARY KEY,
    amabilidad INT,
    exactitud INT,
    cuenta VARCHAR(10), --FK
    fecha DATE
);
ALTER TABLE encuestas
ADD CONSTRAINT fk_encuesta_cuenta
FOREIGN KEY (cuenta)
REFERENCES cuentas(id_cuenta);

ALTER TABLE encuestas
ADD empleado VARCHAR(10);
-- \Encuesta

-- Quejas
CREATE TABLE quejas(
    id_queja VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(50),
    fecha DATE,
    motivo TEXT,
    gravedad INT,
    empleado VARCHAR(10) NULL, --FK
    alimento VARCHAR(10) NULL --FK
);
ALTER TABLE quejas
ADD CONSTRAINT fk_queja_empleado
FOREIGN KEY (empleado)
REFERENCES empleados(id_empleado),
ADD CONSTRAINT fk_queja_alimento
FOREIGN KEY (alimento)
REFERENCES menu(id_alimento);
-- \Quejas

-- Pedidos
CREATE TABLE pedidos(
    cuenta VARCHAR(10), --FK
    alimento VARCHAR(10), --FK
    tiempo TIMESTAMP
);
ALTER TABLE pedidos
ADD CONSTRAINT fk_pedido_cuenta
FOREIGN KEY (cuenta)
REFERENCES cuentas(id_cuenta),
ADD CONSTRAINT fk_pedido_alimento
FOREIGN KEY (alimento)
REFERENCES menu(id_alimento);
-- \Pedidos

-- Factura
CREATE TABLE facturas(
    id_factura VARCHAR(10) PRIMARY KEY,
    nit VARCHAR(9),
    nombre VARCHAR(50),
    direccion VARCHAR(50),
    monto DOUBLE PRECISION,
    metodo_pago VARCHAR(50),
    fecha DATE,
    cuenta VARCHAR(10) --FK
);
ALTER TABLE facturas
ADD CONSTRAINT fk_factura_cuenta
FOREIGN KEY (cuenta)
REFERENCES cuentas(id_cuenta);
-- \Pedidos

COMMIT;


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



--- PROCEDIMIENTOS

CREATE OR REPLACE FUNCTION auth_credentials(username VARCHAR(10), password VARCHAR(50))
RETURNS BOOLEAN AS
$$
DECLARE
    user_exists BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1
        FROM empleados
        WHERE id_empleado = username AND contrasena = crypt(password, contrasena)
    ) INTO user_exists;
    RETURN user_exists;
END;
$$
LANGUAGE plpgsql;

--Función para obtener los detalles del pedido

CREATE OR REPLACE FUNCTION reporte_facturas_por_parametros(
    _nombre VARCHAR(50), 
    _nit VARCHAR(9), 
    _metodo_pago VARCHAR(50))
RETURNS TABLE (
    id_factura VARCHAR(10), 
    nit VARCHAR(9), 
    nombre VARCHAR(50), 
    direccion VARCHAR(50), 
    monto_efectivo DOUBLE PRECISION, 
    monto_tarjeta DOUBLE PRECISION, 
    monto_total DOUBLE PRECISION, 
    fecha DATE, 
    cuenta VARCHAR(10))
AS $$
BEGIN
    RETURN QUERY 
    SELECT f.id_factura, f.nit, f.nombre, f.direccion, 
           f.monto_efectivo, f.monto_tarjeta, f.monto_total, 
           f.fecha, f.cuenta
    FROM facturas f
    JOIN cuentas c ON f.cuenta = c.id_cuenta
    WHERE f.nombre ILIKE _nombre AND f.nit = _nit
    AND (
        (_metodo_pago = 'Efectivo' AND f.monto_efectivo > 0 AND f.monto_tarjeta = 0) OR
        (_metodo_pago = 'Tarjeta' AND f.monto_tarjeta > 0 AND f.monto_efectivo = 0) OR
        (_metodo_pago = 'Ambas' AND f.monto_efectivo > 0 AND f.monto_tarjeta > 0)
    )
    AND c.estado = FALSE
    ORDER BY f.fecha DESC;
END;
$$ LANGUAGE plpgsql;

COMMIT;
--Procedimiento para obtner la cuenta
CREATE OR REPLACE FUNCTION cerrar_cuenta_generar_factura(
    _id_cuenta VARCHAR(10),
    _porcentaje_propina NUMERIC,
    _cantidad_personas INT)
RETURNS TABLE (
    nombre_alimento VARCHAR(50),
    precio_alimento DOUBLE PRECISION, -- Tipo corregido a DOUBLE PRECISION
    subtotal DOUBLE PRECISION, -- Tipo corregido a DOUBLE PRECISION
    total_con_propina DOUBLE PRECISION, -- Tipo corregido a DOUBLE PRECISION
    pago_por_persona DOUBLE PRECISION) -- Tipo corregido a DOUBLE PRECISION
AS $$
DECLARE
    _subtotal DOUBLE PRECISION := 0;
    _total DOUBLE PRECISION;
    _pago_individual DOUBLE PRECISION;
BEGIN
    -- Calcular el subtotal de los alimentos de la cuenta
    SELECT SUM(m.precio) INTO _subtotal
    FROM pedidos AS p
    JOIN menu AS m ON p.alimento = m.id_alimento
    WHERE p.cuenta = _id_cuenta;

    -- Calcular el total incluyendo propina
    _total := _subtotal + (_subtotal * (_porcentaje_propina / 100.0));

    -- Calcular el pago por persona
    _pago_individual := _total / _cantidad_personas;

    -- Marcar la cuenta como cerrada y fijar la hora de cierre
    UPDATE cuentas SET estado = FALSE, tiempo_carrada = CURRENT_TIMESTAMP
    WHERE id_cuenta = _id_cuenta AND estado = TRUE;

    -- Retornar los detalles de los alimentos y los totales
    RETURN QUERY 
    SELECT m.nombre, m.precio, _subtotal, _total, _pago_individual
    FROM pedidos AS p
    JOIN menu AS m ON p.alimento = m.id_alimento
    WHERE p.cuenta = _id_cuenta;

END;
$$ LANGUAGE plpgsql;

COMMIT;


--Procedimiento para update de la tabla de cuenta y generar factura
CREATE OR REPLACE FUNCTION generar_factura(
    _num_cuenta VARCHAR, 
    _nit VARCHAR, 
    _nombre VARCHAR, 
    _direccion VARCHAR, 
    _monto_efectivo NUMERIC, 
    _monto_tarjeta NUMERIC, 
    _subtotal NUMERIC,
    _porcentaje_propina NUMERIC
)
RETURNS VOID AS $$
DECLARE
    nuevo_correlativo VARCHAR;
    ultimo_correlativo INT;
    monto_total_con_propina NUMERIC;
    monto_efectivo_sin_propina NUMERIC;
    monto_tarjeta_sin_propina NUMERIC;
BEGIN
    -- Calcula el total con propina
    monto_total_con_propina := _subtotal * (1 + _porcentaje_propina / 100);

    -- Calcula los montos sin propina en base a la proporción del subtotal en el total con propina
    monto_efectivo_sin_propina := (_monto_efectivo / monto_total_con_propina) * _subtotal;
    monto_tarjeta_sin_propina := (_monto_tarjeta / monto_total_con_propina) * _subtotal;

    -- Encuentra el correlativo más alto de las facturas y le suma uno
    SELECT COALESCE(MAX(CAST(SUBSTR(id_factura, 2) AS INT)), 0) + 1 INTO ultimo_correlativo
    FROM facturas;
    
    -- Genera el nuevo correlativo como string
	nuevo_correlativo := 'F' || LPAD(ultimo_correlativo::TEXT, 3, '0');
    
    -- Inserta la nueva factura en la base de datos con montos sin propina
    INSERT INTO facturas(id_factura, nit, nombre, direccion, monto_efectivo, monto_tarjeta, monto_total, fecha, cuenta)
    VALUES (nuevo_correlativo, _nit, _nombre, _direccion, monto_efectivo_sin_propina, monto_tarjeta_sin_propina, _subtotal, CURRENT_DATE, _num_cuenta);
    
    -- Actualiza el estado de la cuenta
    UPDATE cuentas SET estado = FALSE WHERE id_cuenta = _num_cuenta;
END;
$$ LANGUAGE plpgsql;

COMMIT;


--Reportes

--1
CREATE OR REPLACE FUNCTION reporte_platos_mas_pedidos(fecha_inicio DATE, fecha_fin DATE)
RETURNS TABLE (alimento VARCHAR(50), cantidad_pedidos INT) AS $$
BEGIN
    RETURN QUERY 
    SELECT m.nombre AS alimento, COUNT(*)::INT AS cantidad_pedidos
    FROM pedidos p
    JOIN menu m ON p.alimento = m.id_alimento
    WHERE p.tiempo BETWEEN fecha_inicio AND fecha_fin
    GROUP BY m.nombre
    ORDER BY cantidad_pedidos DESC;
END;
$$ LANGUAGE plpgsql;

commit;

--select*from reporte_platos_mas_pedidos('2024-04-12', '2024-04-16');

--2
CREATE OR REPLACE FUNCTION reporte_horario_pedido(fecha_inicio DATE, fecha_fin DATE)
RETURNS TABLE (horario TEXT, cantidad_pedidos INT) AS $$
BEGIN
    RETURN QUERY 
    SELECT CASE
               WHEN EXTRACT(HOUR FROM tiempo) >= 6 AND EXTRACT(HOUR FROM tiempo) < 12 THEN 'mañana'
               WHEN EXTRACT(HOUR FROM tiempo) >= 12 AND EXTRACT(HOUR FROM tiempo) < 18 THEN 'tarde'
               ELSE 'noche'
           END AS horario,
           COUNT(*)::INT AS cantidad_pedidos
    FROM pedidos
    WHERE tiempo BETWEEN fecha_inicio AND fecha_fin
    GROUP BY horario
    ORDER BY cantidad_pedidos DESC;
END;
$$ LANGUAGE plpgsql;

commit;

--SELECT * FROM reporte_horario_pedido('2024-04-01', '2024-04-30');

--3
CREATE OR REPLACE FUNCTION reporte_tiempo_promedio_comer(fecha_inicio DATE, fecha_fin DATE)
RETURNS TABLE (cantidad_personas INT, tiempo_promedio INTERVAL) AS $$
BEGIN
    RETURN QUERY 
    SELECT c.personas AS cantidad_personas, 
           AVG(c.tiempo_carrada - c.tiempo_abierta) AS tiempo_promedio
    FROM cuentas c
    WHERE c.tiempo_carrada IS NOT NULL
    AND c.tiempo_carrada BETWEEN fecha_inicio AND fecha_fin
    GROUP BY c.personas;
END;
$$ LANGUAGE plpgsql;

commit;

--select*from reporte_tiempo_promedio_comer('2024-04-12', '2024-04-16');

--4
CREATE OR REPLACE FUNCTION reporte_quejas_por_persona(fecha_inicio DATE, fecha_fin DATE)
RETURNS TABLE (persona VARCHAR(50), cantidad_quejas INT) AS $$
BEGIN
    RETURN QUERY 
    SELECT e.nombre AS persona, COUNT(*)::INT AS cantidad_quejas
    FROM quejas q
    JOIN empleados e ON q.empleado = e.id_empleado
    WHERE q.fecha BETWEEN fecha_inicio AND fecha_fin
    GROUP BY e.nombre
    ORDER BY cantidad_quejas DESC;
END;
$$ LANGUAGE plpgsql;

commit;

--select*from reporte_quejas_por_persona('2024-04-12', '2024-04-16');

--5
CREATE OR REPLACE FUNCTION reporte_quejas_por_plato(fecha_inicio DATE, fecha_fin DATE)
RETURNS TABLE (plato VARCHAR(50), cantidad_quejas INT) AS $$
BEGIN
    RETURN QUERY 
    SELECT m.nombre AS plato, COUNT(*)::INT AS cantidad_quejas
    FROM quejas q
    JOIN menu m ON q.alimento = m.id_alimento
    WHERE q.fecha BETWEEN fecha_inicio AND fecha_fin
    GROUP BY m.nombre
    ORDER BY cantidad_quejas DESC;
END;
$$ LANGUAGE plpgsql;

commit;

--select*from reporte_quejas_por_plato('2024-04-12', '2024-04-16');

--6
CREATE OR REPLACE FUNCTION reporte_eficiencia_meseros()
RETURNS TABLE (año INT, mes INT, mesero VARCHAR(50), amabilidad_promedio NUMERIC, exactitud_promedio NUMERIC) AS $$
BEGIN
    RETURN QUERY 
    SELECT EXTRACT(YEAR FROM e.fecha)::int AS año, 
           EXTRACT(MONTH FROM e.fecha)::int AS mes, 
           emp.nombre AS mesero,  
           AVG(e.amabilidad) AS amabilidad_promedio, 
           AVG(e.exactitud) AS exactitud_promedio
    FROM encuestas e
    JOIN empleados emp ON emp.id_empleado = e.empleado  
    WHERE e.fecha BETWEEN CURRENT_DATE - INTERVAL '6 months' AND CURRENT_DATE
    GROUP BY año, mes, mesero
    ORDER BY año DESC, mes DESC;
END;
$$ LANGUAGE plpgsql;

commit;

--select*from reporte_eficiencia_meseros();
