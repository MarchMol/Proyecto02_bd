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

select*from reporte_quejas_por_plato('2024-04-12', '2024-04-16');

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
