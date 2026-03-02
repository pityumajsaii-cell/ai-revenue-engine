from fastapi import FastAPI
import os

app = FastAPI(title="AI Revenue Engine")

@app.get("/")
def home():
    return {"status": "AI Revenue Engine LIVE"}

@app.get("/health")
def health():
    return {"health": "ok"}

@app.get("/generate")
def generate(text: str):
    return {"result": f"Generated content for: {text}"}
