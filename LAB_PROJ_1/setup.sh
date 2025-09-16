echo "Setting up Jenkins CI/CD Demo..."
mkdir -p jenkins_data
sudo chmod 755 jenkins_data
echo "Starting Docker containers..."
docker-compose up -d
echo "Waiting for Jenkins to start..."
sleep 30
echo "Getting Jenkins initial admin password..."
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
echo ""
echo "Setup complete!"
echo ""
echo "Jenkins is available at: http://localhost:8080"
echo "Litestar API is available at: http://localhost:8000"
echo ""
echo "Next steps:"
echo "1. Open http://localhost:8080 in your browser"
echo "2. Use the admin password shown above to unlock Jenkins"
echo "3. Install suggested plugins"
echo "4. Create an admin user"
echo "5. Set up Docker Hub credentials in Jenkins (Manage Jenkins > Manage Credentials)"
echo "6. Create a new pipeline job and point it to your repository"
echo ""

# docker-compose down
# to stop it