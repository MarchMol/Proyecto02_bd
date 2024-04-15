import psycopg2

def connection() :
    try:
        connection = psycopg2.connect(
            dbname='', # Nombre de la Base de datos
            user='postgres',
            password='', # Contraseña
            host='localhost',
            port=5432
        )
        print("Connected to the database!")

        return connection
        
    except psycopg2.Error as e:
        print("Unable to connect to the database :( ", e)
  


    

