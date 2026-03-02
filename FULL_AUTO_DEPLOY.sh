#!/data/data/com.termux/files/usr/bin/bash

echo "======================================="
echo " AI REVENUE ENGINE - FULL AUTO DEPLOY "
echo "======================================="

PROJECT_DIR=~/linkedin_revenue_engine/ai_revenue_saas
REPO_NAME=ai-revenue-engine
GITHUB_USER=pityumajsaii-cell

cd $PROJECT_DIR || exit

read -p "Add meg a GitHub Personal Access Token-t: " GHTOKEN

echo ""
echo ">> Git config..."
git config --global user.name "$GITHUB_USER"
git config --global user.email "$GITHUB_USER@users.noreply.github.com"

echo ""
echo ">> Repo létrehozása GitHubon (ha nem létezik)..."
curl -s -H "Authorization: token $GHTOKEN" \
     -H "Accept: application/vnd.github+json" \
     https://api.github.com/user/repos \
     -d "{\"name\":\"$REPO_NAME\",\"private\":false}" > /dev/null

echo ""
echo ">> Git init..."
git init

echo ">> Remote reset..."
git remote remove origin 2>/dev/null

echo ">> Remote beállítás..."
git remote add origin https://$GITHUB_USER:$GHTOKEN@github.com/$GITHUB_USER/$REPO_NAME.git

echo ">> Branch main..."
git branch -M main

echo ">> Add & Commit..."
git add .
git commit -m "Production deploy" 2>/dev/null

echo ">> Push GitHub..."
git push -u origin main --force

echo ""
echo "======================================="
echo " KÉSZ."
echo ""
echo "Most menj ide:"
echo "https://render.com"
echo ""
echo "New → Web Service → Connect GitHub"
echo "Repo: $REPO_NAME"
echo ""
echo "Build Command:"
echo "pip install -r requirements.txt"
echo ""
echo "Start Command:"
echo "gunicorn -k uvicorn.workers.UvicornWorker main:app"
echo "======================================="
