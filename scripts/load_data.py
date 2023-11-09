import psycopg2
import redis
import os

POSTGRES_HOST = os.getenv("POSTGRES_HOST", "localhost")
POSTGRES_DB = os.getenv("POSTGRES_DB", "wordpress")
POSTGRES_USER = os.getenv("POSTGRES_USER", "username")
POSTGRES_PASSWORD = os.getenv("POSTGRES_PASSWORD", "password")
REDIS_HOST = os.getenv("REDIS_HOST", "localhost")
REDIS_PORT = os.getenv("REDIS_PORT", 6379)

def load_data_postgres():
    try:
        conn = psycopg2.connect(
            host=POSTGRES_HOST,
            database=POSTGRES_DB,
            user=POSTGRES_USER,
            password=POSTGRES_PASSWORD
        )

        cur = conn.cursor()
        cur.close()
        conn.commit()
    except Exception as e:
        print("Erro ao carregar dados no PostgreSQL:", e)
    finally:
        if conn:
            conn.close()

# Função para carregar dados no Redis
def load_data_redis():
    try:
        r = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, decode_responses=True)

        # Adicionar dados de exemplo
        # r.set("chave", "valor")

    except Exception as e:
        print("Erro ao carregar dados no Redis:", e)

if __name__ == "__main__":
    load_data_postgres()
    load_data_redis()
