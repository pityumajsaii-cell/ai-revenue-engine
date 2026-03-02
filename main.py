import os
import stripe
from fastapi import FastAPI, Depends, HTTPException, Request
from fastapi.security import HTTPBearer
from jose import jwt
from passlib.context import CryptContext
from sqlalchemy import create_engine, Column, Integer, String, Float, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, relationship
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")
JWT_SECRET = os.getenv("JWT_SECRET")
STRIPE_SECRET_KEY = os.getenv("STRIPE_SECRET_KEY")
STRIPE_WEBHOOK_SECRET = os.getenv("STRIPE_WEBHOOK_SECRET")

stripe.api_key = STRIPE_SECRET_KEY

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(bind=engine)
Base = declarative_base()

app = FastAPI()
security = HTTPBearer()
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# ==============================
# MODELS
# ==============================

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True)
    email = Column(String, unique=True)
    password = Column(String)
    tenant_id = Column(Integer, ForeignKey("tenants.id"))

class Tenant(Base):
    __tablename__ = "tenants"
    id = Column(Integer, primary_key=True)
    name = Column(String)
    users = relationship("User")

class Prospect(Base):
    __tablename__ = "prospects"
    id = Column(Integer, primary_key=True)
    tenant_id = Column(Integer)
    name = Column(String)
    expected_profit = Column(Float)

Base.metadata.create_all(bind=engine)

# ==============================
# AUTH
# ==============================

def create_token(data: dict):
    return jwt.encode(data, JWT_SECRET, algorithm="HS256")

@app.post("/register")
def register(email: str, password: str):
    db = SessionLocal()
    hashed = pwd_context.hash(password)
    tenant = Tenant(name=email.split("@")[0])
    db.add(tenant)
    db.commit()
    db.refresh(tenant)
    user = User(email=email, password=hashed, tenant_id=tenant.id)
    db.add(user)
    db.commit()
    return {"message": "User created"}

@app.post("/login")
def login(email: str, password: str):
    db = SessionLocal()
    user = db.query(User).filter(User.email == email).first()
    if not user or not pwd_context.verify(password, user.password):
        raise HTTPException(status_code=401, detail="Invalid credentials")
    token = create_token({"user_id": user.id, "tenant_id": user.tenant_id})
    return {"token": token}

# ==============================
# STRIPE WEBHOOK
# ==============================

@app.post("/stripe/webhook")
async def stripe_webhook(request: Request):
    payload = await request.body()
    sig_header = request.headers.get("stripe-signature")
    event = stripe.Webhook.construct_event(
        payload, sig_header, STRIPE_WEBHOOK_SECRET
    )
    return {"status": "received"}

@app.get("/")
def health():
    return {"status": "AI Revenue SaaS Running"}
