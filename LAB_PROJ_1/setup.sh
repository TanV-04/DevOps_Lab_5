#!/usr/bin/env bash
set -e

echo "🚀 Setting up Jenkins CI/CD Demo..."

# Create Jenkins data folder (no sudo)
mkdir -p jenkins_data
chmod 755 jenkins_data

echo "🐳 Starting Docker containers..."
docker-compose up -d --build

echo "⏳ Waiting for Jenkins to start (may take ~1–2 minutes)..."
sleep 45

echo "🔑 Getting Jenkins initial admin password..."
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword || echo "Password not ready yet."

echo ""
echo "✅ Setup complete!"
echo "📌 Jenkins: http://localhost:8090"
echo "📌 Litestar API: http://localhost:8000"
echo ""
echo "Next steps:"
echo "1. Open Jenkins in browser and unlock with password above"
echo "2. Install suggested plugins"
echo "3. Create a new admin user"
echo "4. Add Docker Hub credentials (ID: dockerhub-credentials)"
echo "5. Create a new Pipeline job pointing to your repo"
echo ""
echo "To stop services: docker-compose down"
