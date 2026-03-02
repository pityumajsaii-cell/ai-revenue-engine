#!/data/data/com.termux/files/usr/bin/bash

echo "======================================"
echo "AI REVENUE ENGINE - FULL AUTO INSTALL"
echo "======================================"

echo "Cleaning old broken setup..."
rm -rf venv
rm -f main.py
rm -f start.sh

echo "Updating Termux..."
pkg update -y
pkg upgrade -y

echo "Installing required packages..."
pkg install python git curl cloudflared -y

echo "Creating fresh virtual environment..."
python -m venv venv
source venv/bin/activate

echo "Upgrading pip..."
pip install --upgrade pip

echo "Installing FastAPI and Uvicorn..."
pip install fastapi uvicorn

echo "Creating working FastAPI app..."
cat > main.py <<EOF
from fastapi import FastAPI

app = FastAPI(title="AI Revenue Engine")

@app.get("/")
def home():
    return {"status": "AI Revenue Engine Running"}

@app.get("/health")
def health():
    return {"health": "ok"}
EOF

echo "Starting backend..."
venv/bin/uvicorn main:app --host 0.0.0.0 --port 8000 &
sleep 5

echo "Starting Cloudflare Tunnel..."
cloudflared tunnel --url http://localhost:8000
