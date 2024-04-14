-- TABLAS Y LLAVES --

BEGIN;
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
    area VARCHAR(10) NULL --FK
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