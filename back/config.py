from dotenv import load_dotenv
import os

load_dotenv()


DB_USER = os.getenv("DB_USER", "postgres")
DB_PASS = os.getenv("DB_PASS", "VovaF2513")
DB_HOST = os.getenv("DB_HOST", "db")
DB_PORT = os.getenv("DB_PORT", "5432")
DB_NAME = os.getenv("DB_NAME", "postgres")
SECRET_KEY=os.environ.get('SECRET_KEY')