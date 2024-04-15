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
