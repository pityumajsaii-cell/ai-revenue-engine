#!/data/data/com.termux/files/usr/bin/bash

echo "========================================"
echo " AI REVENUE ENGINE - ONE CLICK DEPLOY"
echo "========================================"

REPO_NAME=ai-revenue-engine
GITHUB_USER=pityumajsaii-cell
PROJECT_DIR=~/linkedin_revenue_engine/ai_revenue_saas

cd $PROJECT_DIR || exit

read -p "GitHub Personal Access Token: " GHTOKEN

echo ""
echo ">> Production app setup..."

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
echo "========================================"
echo " KÉSZ."
echo ""
echo "Most nyisd meg ezt a linket:"
echo ""
echo "https://render.com/deploy?repo=https://github.com/$GITHUB_USER/$REPO_NAME"
echo ""
echo "Ott csak jóvá kell hagyni."
echo "========================================"
