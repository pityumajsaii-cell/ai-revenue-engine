#!/data/data/com.termux/files/usr/bin/bash

echo "========================================="
echo " AI REVENUE ENGINE - FULL ONLINE DEPLOY "
echo "========================================="

REPO_NAME=ai-revenue-engine
GITHUB_USER=pityumajsaii-cell
PROJECT_DIR=~/linkedin_revenue_engine/ai_revenue_saas

cd $PROJECT_DIR || exit

read -p "GitHub Personal Access Token: " GHTOKEN
read -p "Render API Key: " RENDERKEY

echo ""
echo ">> Production app létrehozás..."

cat > main.py <<EOF
from fastapi import FastAPI

app = FastAPI(title="AI Revenue Engine")

@app.get("/")
def home():
    return {"status": "AI Revenue Engine LIVE"}
EOF

echo "fastapi" > requirements.txt
echo "uvicorn" >> requirements.txt
echo "gunicorn" >> requirements.txt

echo ""
echo ">> Git push..."

git init
git remote remove origin 2>/dev/null
git branch -M main
git remote add origin https://$GITHUB_USER:$GHTOKEN@github.com/$GITHUB_USER/$REPO_NAME.git
git add .
git commit -m "Production deploy" 2>/dev/null
git push -u origin main --force

echo ""
echo ">> Render Service létrehozás..."

SERVICE_JSON=$(curl -s -X POST https://api.render.com/v1/services \
  -H "Authorization: Bearer $RENDERKEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"type\": \"web_service\",
    \"name\": \"$REPO_NAME\",
    \"env\": \"python\",
    \"repo\": \"https://github.com/$GITHUB_USER/$REPO_NAME\",
    \"branch\": \"main\",
    \"buildCommand\": \"pip install -r requirements.txt\",
    \"startCommand\": \"gunicorn -k uvicorn.workers.UvicornWorker main:app\"
  }")

echo ""
echo "========================================="
echo "ONLINE DEPLOY ELINDÍTVA"
echo "========================================="
echo ""
echo "Menj ide és nézd a buildet:"
echo "https://dashboard.render.com"
echo ""
echo "Ha kész, az URL valami ilyesmi lesz:"
echo "https://$REPO_NAME.onrender.com"
echo "========================================="
