import psycopg2
import redis
import os
import logging

# Configuração de logging
logging.basicConfig(level=logging.INFO)

POSTGRES_HOST = os.getenv("POSTGRES_HOST", "localhost")
POSTGRES_DB = os.getenv("POSTGRES_DB", "wordpress")
POSTGRES_USER = os.getenv("POSTGRES_USER", "username")
POSTGRES_PASSWORD = os.getenv("POSTGRES_PASSWORD")
REDIS_HOST = os.getenv("REDIS_HOST", "localhost")
REDIS_PORT = os.getenv("REDIS_PORT", 6379)

def load_data_postgres():
    try:
        with psycopg2.connect(
            host=POSTGRES_HOST,
            database=POSTGRES_DB,
            user=POSTGRES_USER,
            password=POSTGRES_PASSWORD
        ) as conn:
            with conn.cursor() as cur:
                pass
    except psycopg2.DatabaseError as e:
        logging.error(f"Erro ao carregar dados no PostgreSQL: {e}")
    except Exception as e:
        logging.error(f"Erro inesperado: {e}")

def load_data_redis():
    try:
        r = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, decode_responses=True)
        # Adicionar dados de exemplo
        # r.set("chave", "valor")
    except redis.RedisError as e:
        logging.error(f"Erro ao carregar dados no Redis: {e}")
    except Exception as e:
        logging.error(f"Erro inesperado: {e}")

if __name__ == "__main__":
    load_data_postgres()
    load_data_redis()
