#!/data/data/com.termux/files/usr/bin/bash

export ANDROID_API_LEVEL=24
source venv/bin/activate

echo "Starting FastAPI..."
venv/bin/uvicorn main:app --host 0.0.0.0 --port 8000 &
sleep 5

echo "Starting Cloudflare Tunnel..."
cloudflared tunnel --url http://localhost:8000
