#!/data/data/com.termux/files/usr/bin/bash

echo "Updating Termux..."
pkg update -y && pkg upgrade -y

echo "Installing system packages..."
pkg install python wget curl cloudflared -y

echo "Upgrading pip..."
python3 -m pip install --upgrade pip

echo "Installing Python dependencies..."
if [ -f requirements.txt ]; then
    python3 -m pip install -r requirements.txt
else
    python3 -m pip install fastapi uvicorn sqlalchemy stripe
fi

echo "Creating start script..."

cat > start.sh << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash

echo "Starting FastAPI..."
uvicorn main:app --host 0.0.0.0 --port 8000 &
sleep 5

echo "Starting Cloudflare Tunnel..."
cloudflared tunnel --url http://localhost:8000
EOF

chmod +x start.sh

echo ""
echo "======================================"
echo "INSTALL COMPLETE"
echo "Run your system with:"
echo "./start.sh"
echo "======================================"
