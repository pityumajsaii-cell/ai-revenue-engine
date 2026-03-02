#!/data/data/com.termux/files/usr/bin/bash

echo "======================================"
echo "AI REVENUE ENGINE - FULL CLEAN INSTALL"
echo "======================================"

echo "Cleaning old environment..."
rm -rf venv
rm -f main.py
rm -f start.sh

echo "Updating Termux..."
pkg update -y
pkg upgrade -y

echo "Installing system dependencies..."
pkg install python git curl cloudflared -y

echo "Creating virtual environment..."
python -m venv venv
source venv/bin/activate

echo "Upgrading pip..."
pip install --upgrade pip

echo "Installing Python packages..."
pip install fastapi uvicorn

echo "Creating main.py..."
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

echo "Creating start.sh..."
cat > start.sh <<EOF
#!/data/data/com.termux/files/usr/bin/bash

export ANDROID_API_LEVEL=24
source venv/bin/activate

echo "Starting FastAPI..."
venv/bin/uvicorn main:app --host 0.0.0.0 --port 8000 &
sleep 5

echo "Starting Cloudflare Tunnel..."
cloudflared tunnel --url http://localhost:8000
EOF

chmod +x start.sh

echo ""
echo "======================================"
echo "INSTALL COMPLETE"
echo "Run:"
echo "./start.sh"
echo "======================================"
