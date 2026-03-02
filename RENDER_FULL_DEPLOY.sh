#!/data/data/com.termux/files/usr/bin/bash

echo "======================================"
echo "AI REVENUE ENGINE - RENDER DEPLOY"
echo "======================================"

echo "Cleaning old setup..."
rm -rf venv
rm -f requirements.txt
rm -f Procfile

pkg update -y
pkg install python git -y

echo "Creating virtual environment..."
python -m venv venv
source venv/bin/activate
pip install --upgrade pip

echo "Installing production dependencies..."
pip install fastapi uvicorn gunicorn

echo "Generating requirements.txt..."
pip freeze > requirements.txt

echo "Creating production FastAPI app..."

cat > main.py <<EOF
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
EOF

echo "Creating Procfile..."
cat > Procfile <<EOF
web: gunicorn -k uvicorn.workers.UvicornWorker main:app
EOF

echo "Initializing Git..."
git init
git add .
git commit -m "Production deploy"

echo ""
echo "======================================"
echo "NEXT STEP:"
echo "1. Create empty GitHub repository"
echo "2. Run:"
echo ""
echo "git remote add origin https://github.com/YOURUSERNAME/YOURREPO.git"
echo "git branch -M main"
echo "git push -u origin main"
echo ""
echo "3. Go to render.com"
echo "4. New Web Service"
echo "5. Connect GitHub repo"
echo "6. Start Command:"
echo "   gunicorn -k uvicorn.workers.UvicornWorker main:app"
echo ""
echo "DONE."
echo "======================================"
