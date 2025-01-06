#!/bin/bash

# Creates root's directories
mkdir -p files
mkdir -p models
mkdir -p models/pydantic
mkdir -p models/sqlalchemy
mkdir -p routers
mkdir -p utils

# Creates helpers file
touch utils/helpers.py


# Creates requiremnts file
touch requirements.txt
cat <<EOL > requirements.txt
sqlalchemy
alembic
psycopg2-binary
pydantic==2.8.2
uvicorn
fastapi==0.112.0
python-multipart
fastapi_pagination
requests
python-dotenv
passlib[bcrypt]
python-jose
EOL

# Creates main file
touch main.py
cat <<EOL > main.py
from fastapi import FastAPI

load_dotenv()
origins = os.getenv("ORIGINS")

app = FastAPI()

# Middleware for CORS
app.add_middleware(
    CORSMiddleware,
    allow_credentials=True,
    allow_origins=origins,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def read_root():
    return {"message": "Welcome to the API"}
EOL


# Creates env file
touch .env
cat <<EOL > .env
DEBUG=True
DB_URL=
SECRET_KEY=
ORIGINS=["*"]
EOL


# Creates user model
touch models/pydantic/base.py
cat <<EOL > models/pydantic/base.py
from pydantic import BaseModel


class BaseModelConfig(BaseModel):
    class Config:
        orm_mode = True


EOL


touch models/pydantic/user.py
cat <<EOL > models/pydantic/user.py
from pydantic import BaseModel, Field

class UserLogin(BaseModel):
    email: str
    password: str


class User(BaseModel):
    id: str
    firstname: str
    lastname: str
    email: str
    password: str
    status: int
EOL



touch models/sqlalchemy/base.py
cat <<EOL > models/sqlalchemy/base.py

from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

EOL


touch models/sqlalchemy/user.py
cat <<EOL > models/sqlalchemy/user.py
from sqlalchemy import Column, String, Integer
from models.sqlalchemy.base import Base
import uuid


class User(Base):
    __tablename__ = "users"

    id = Column(String, primary_key=True, index=True, default=lambda: str(uuid.uuid4()))
    firstname = Column(String)
    lastname = Column(String)
    email = Column(String, unique=True, index=True)
    password = Column(String)
    status = Column(Integer, default=1)

EOL

echo "Files generated successfully !!"