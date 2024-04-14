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
