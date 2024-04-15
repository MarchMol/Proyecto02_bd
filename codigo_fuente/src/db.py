from src.conn import connection
import psycopg2

def LogIn(id, password):
    try: 
        con = connection()  
        cursor = con.cursor()
        query = "SELECT * FROM auth_credentials(\'" + id +"\','"+ password+ "\')"
        cursor.execute(query)
        result = cursor.fetchone()[0]
        cursor.close()
        con.close()
        return result
    except:
        print('Ocurrio un error verificando el usuario.')
        return False

def getNextId():
    try: 
        con = connection()  
        cursor = con.cursor()
        query = "SELECT COUNT(*) FROM empleados"
        cursor.execute(query)
        result = cursor.fetchone()[0]
        cursor.close()
        con.close()
        return result
    except:
        print('Ocurrio un error verificando el usuario.')
        return 0
    
def SignIn(id, contrasena, nombre, rol):
    try: 
        con = connection()  
        cursor = con.cursor()
        query = "INSERT INTO empleados(id_empleado, nombre, rol, area, contrasena) VALUES (%s, %s, %s, NULL, crypt(%s, gen_salt('bf')));"
        cursor.execute(query, (id, nombre, rol, contrasena))
        con.commit() 
        count = cursor.rowcount
        cursor.close()
        con.close()
        if count > 0:
            print("Insert successful. The amount of users inserted is:", count)
            return True
        else:
            print("No rows were affected. Insert probably failed.")
            return False


    except psycopg2.Error as e:
        print('Ocurrio un error agregando el usuario:',e)
        return False

# Funcion para obtener las mesas y las cuentas a las que estan asociadas:
def fetch_tables():
    try:
        with connection() as con:
            with con.cursor() as cursor:
                query = "SELECT id_mesa FROM mesas"
                cursor.execute(query)
                return cursor.fetchall()
    except Exception as e:
        print('Error fetching tables:', e)
        return []

# Función obtiene todas las cuentas asociadas a una mesa
def fetch_bills(id_mesa):
    try:
        con = connection()  
        cursor = con.cursor()
        query = "SELECT id_cuenta, mesa FROM cuentas WHERE mesa = %s AND estado = True;"
        cursor.execute(query,(id_mesa,))
        result = cursor.fetchall()
        cursor.close()
        con.close()
        return result
    except Exception as e:
        print('Error fetching tables:', e)
        return []

# Función obtiene todas las ordenes de una cuenta
def fetchOrders(id_cuenta):
    try:
        con = connection()  
        cursor = con.cursor()
        query = "SELECT nombre, precio, tiempo FROM pedidos INNER JOIN menu on pedidos.alimento = menu.id_alimento where cuenta=%s;"
        cursor.execute(query,(id_cuenta,))
        result = cursor.fetchall()
        cursor.close()
        con.close()
        return result
    except Exception as e:
        print('Error fetching tables:', e)
        return []

# Función obtiene todos los elementos del menú
def fetchMenu():
    try:
        con = connection()  
        cursor = con.cursor()
        query = "SELECT nombre, id_alimento FROM menu"
        cursor.execute(query,)
        result = cursor.fetchall()
        cursor.close()
        con.close()
        return result
    except Exception as e:
        print('Error fetching nect bill:', e)
        return []

# Función cuenta todas las cuentas actuales
def nextBill():
    try:
        con = connection()  
        cursor = con.cursor()
        query = "SELECT count(id_cuenta) FROM cuentas"
        cursor.execute(query)
        result = cursor.fetchone()
        cursor.close()
        con.close()
        return result
    except Exception as e:
        print('Error fetching nect bill:', e)
        return []

# Función para insertar un alimento en la tabla Pedidos
def insertOrder(cuenta, alimento):
    try:
        con = connection()  
        cursor = con.cursor()
        query = "INSERT INTO pedidos(cuenta, alimento, tiempo) VALUES (%s,%s,CURRENT_TIMESTAMP);"
        cursor.execute(query,(cuenta, alimento))
        con.commit() 
        count = cursor.rowcount
        cursor.close()
        con.close()
        if count > 0:
            print("Insert successful. The amount of users inserted is:", count)
            return True
        else:
            print("No rows weres affected. Insert probably failed.")
            return False
    except Exception as e:
        print('Error Inserting order:', e)
        return False

# Funcion crea nueva cuenta
def create_new_bill(cuenta, mesa):
    try:
        con = connection()  
        cursor = con.cursor()
        query = "INSERT INTO cuentas(id_cuenta, estado, tiempo_abierta, tiempo_carrada, mesa) VALUES (%s, True, CURRENT_TIMESTAMP, NULL, %s);"
        cursor.execute(query,(cuenta, mesa))
        con.commit() 
        count = cursor.rowcount
        cursor.close()
        con.close()
        if count > 0:
            print("Insert successful. The amount of users inserted is:", count)
            return True
        else:
            print("No rows weres affected. Insert probably failed.")
            return False
    except Exception as e:
        print('Error Creating Bill:', e)
        return False

# Función para recuperar los pedidos de la cocina
def fetch_kitchen_orders():
    try:
        with connection() as con:
            with con.cursor() as cursor:
                query = "SELECT m.nombre, p.tiempo FROM pedidos p JOIN menu m ON p.alimento = m.id_alimento JOIN cuentas c ON p.cuenta = c.id_cuenta JOIN mesas me ON c.mesa = me.id_mesa WHERE m.tipo NOT LIKE '%Bebida%' AND c.estado=true ORDER BY p.tiempo;"
                cursor.execute(query)
                return cursor.fetchall()
    except Exception as e:
        print('Error fetching kitchen orders:', e)
        return []

# Función para recuperar los pedidos del bar
def fetch_bar_orders():
    try:
        with connection() as con:
            with con.cursor() as cursor:
                query = "SELECT m.nombre, p.tiempo FROM pedidos p JOIN menu m ON p.alimento = m.id_alimento JOIN cuentas c ON p.cuenta = c.id_cuenta JOIN mesas me ON c.mesa = me.id_mesa WHERE m.tipo LIKE '%Bebida%' AND c.estado=true ORDER BY p.tiempo;"
                cursor.execute(query)
                return cursor.fetchall()
    except Exception as e:
        print('Error fetching bar orders:', e)
        return []
    
# Reporte 1
def PlatosMasPedidos(fecha_inicio, fecha_fin):
    try: 
        con = connection()  
        cursor = con.cursor()
        query = "select*from reporte_platos_mas_pedidos(%s, %s);"
        cursor.execute(query,(fecha_inicio, fecha_fin))
        result = cursor.fetchall()
        cursor.close()
        con.close()
        return result
    except:
        print('Ocurrio un error.')
        return False
# Reporte 2
def HorariosMasPedidos(fecha_inicio, fecha_fin):
    try: 
        con = connection()  
        cursor = con.cursor()
        query = "SELECT * FROM reporte_horario_pedido(%s, %s);"
        cursor.execute(query,(fecha_inicio, fecha_fin))
        result = cursor.fetchall()
        cursor.close()
        con.close()
        return result
    except:
        print('Ocurrio un error.')
        return False
# Reporte 3
def TiempoPromedio(fecha_inicio, fecha_fin):
    try: 
        con = connection()  
        cursor = con.cursor()
        query = "select*from reporte_tiempo_promedio_comer(%s, %s);"
        cursor.execute(query,(fecha_inicio, fecha_fin))
        result = cursor.fetchall()
        cursor.close()
        con.close()
        return result
    except:
        print('Ocurrio un error.')
        return False
# Reporte 4
def QuejasPersonas(fecha_inicio, fecha_fin):
    try: 
        con = connection()  
        cursor = con.cursor()
        query = "select*from reporte_quejas_por_persona(%s, %s);"
        cursor.execute(query,(fecha_inicio, fecha_fin))
        result = cursor.fetchall()
        cursor.close()
        con.close()
        return result
    except:
        print('Ocurrio un error.')
        return False
# Reporte 5
def QuejasporPlato(fecha_inicio, fecha_fin):
    try: 
        con = connection()  
        cursor = con.cursor()
        query = "select*from reporte_quejas_por_plato(%s, %s);"
        cursor.execute(query,(fecha_inicio, fecha_fin))
        result = cursor.fetchall()
        cursor.close()
        con.close()
        return result
    except:
        print('Ocurrio un error.')
        return False
# Reporte 6
def Eficiencia():
    try: 
        con = connection()  
        cursor = con.cursor()
        query = "select*from reporte_eficiencia_meseros();"
        cursor.execute(query)
        result = cursor.fetchall()
        cursor.close()
        con.close()
        return result
    except:
        print('Ocurrio un error')
        return False
# Busqueda de facturas
def buscar_facturas(nombre, nit, metodo_pago):
    try: 
        con = connection()  
        cursor = con.cursor()
        query = "SELECT * FROM reporte_facturas_por_parametros(%s, %s, %s);"
        cursor.execute(query, (nombre, nit, metodo_pago))
        print(cursor.execute(query, (nombre, nit, metodo_pago)))
        result = cursor.fetchall()
        cursor.close()
        con.close()
        return result
    except Exception as e:
        print(f'Ocurrió un error al buscar las facturas: {e}')
        return []
# Calcular Cuenta
def calcular_cuenta(id_cuenta, porcentaje_propina, cantidad_personas):
    try: 
        con = connection()  
        cursor = con.cursor()
        query = "SELECT * FROM cerrar_cuenta_generar_factura(%s, %s, %s);"
        cursor.execute(query, (id_cuenta, porcentaje_propina, cantidad_personas))
        result = cursor.fetchall()
        cursor.close()
        con.close()
        return result
    except psycopg2.Error as e:
        print('Ocurrio un error al cerrar la cuenta:', e)
        return None
# Generar factura 
def generar_factura(num_cuenta, nit, nombre, direccion, monto_efectivo, monto_tarjeta, subtotal, propina):
    try: 
        con = connection()  
        cursor = con.cursor()
        query="SELECT generar_factura(%s, %s, %s,%s, %s, %s,%s, %s);"
        cursor.execute(query,(num_cuenta, nit, nombre, direccion, monto_efectivo, monto_tarjeta, subtotal, propina))
        con.commit() 
        con.close()
        return True
    except psycopg2.Error as e:
        print('Ocurrio un error al generar la factura:', e)
        return None