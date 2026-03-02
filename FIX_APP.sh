#!/data/data/com.termux/files/usr/bin/bash

echo "==============================="
echo "AI REVENUE ENGINE AUTO FIX"
echo "==============================="

# Ensure venv exists
if [ ! -d "venv" ]; then
    echo "Virtualenv not found. Run FIX_INSTALL.sh first."
    exit 1
fi

source venv/bin/activate

echo "Fixing main.py..."

cat > main.py << 'EOF'
from fastapi import FastAPI
from fastapi.responses import JSONResponse

app = FastAPI(title="AI Revenue Engine")

@app.get("/")
def home():
    return {"status": "AI Revenue Engine Running"}

@app.get("/health")
def health():
    return {"health": "ok"}

@app.get("/revenue")
def revenue():
    return {"message": "Revenue endpoint active"}
EOF

echo "Fixing start.sh..."

cat > start.sh << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash

export ANDROID_API_LEVEL=24
source venv/bin/activate

echo "Starting FastAPI..."
uvicorn main:app --host 0.0.0.0 --port 8000 &
sleep 5

echo "Starting Cloudflare Tunnel..."
cloudflared tunnel --url http://localhost:8000
EOF

chmod +x start.sh

echo ""
echo "====================================="
echo "APP FIXED SUCCESSFULLY"
echo "Run now:"
echo "./start.sh"
echo "====================================="
