import psycopg2

def connection() :
    try:
        connection = psycopg2.connect(
            dbname='', # LA DB
            user='postgres',
            password='', #CONTRASEÑA
            host='localhost',
            port=5432
        )
        print("Connected to the database!")

        return connection
        
    except psycopg2.Error as e:
        print("Unable to connect to the database :( ", e)
  


    

