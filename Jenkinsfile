pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = 'docker.io'
        IMAGE_NAME = 'your-dockerhub-username/litestar-app' // <-- change this!
        IMAGE_TAG = "${BUILD_NUMBER}"
        DOCKER_CREDENTIALS = 'dockerhub-credentials'        // set this credential in Jenkins
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Setup Python Environment') {
            steps {
                sh '''
                    python3 -m venv venv
                    . venv/bin/activate
                    python -m pip install --upgrade pip
                    pip install -r requirements.txt
                '''
            }
        }

        stage('Lint and Code Quality') {
            steps {
                sh '''
                    . venv/bin/activate
                    python -m pip install flake8 black
                    flake8 app.py --max-line-length=88 --extend-ignore=E203,W503 || true
                    black --check app.py || true
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def image = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                    docker.withRegistry('https://registry-1.docker.io/', DOCKER_CREDENTIALS) {
                        image.push()
                        image.push('latest')
                    }
                }
            }
        }

        stage('Security Scan') {
            steps {
                sh '''
                    docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
                      -v $(pwd):/tmp/.cache/ aquasec/trivy:latest \
                      image --exit-code 0 --no-progress --format table ${IMAGE_NAME}:${IMAGE_TAG} || true
                '''
            }
        }

        stage('Deploy to Staging') {
            steps {
                sh '''
                    docker stop litestar-app-staging || true
                    docker rm litestar-app-staging || true

                    docker run -d \
                      --name litestar-app-staging \
                      --network jenkins-network \
                      -p 8001:8000 \
                      ${IMAGE_NAME}:${IMAGE_TAG}

                    sleep 8
                '''
            }
        }

        stage('Integration Tests') {
            steps {
                sh '''
                    curl -f http://localhost:8001/ || exit 1
                    curl -f http://localhost:8001/hello || exit 1
                    curl -f http://localhost:8001/info || exit 1
                '''
            }
        }

        stage('Deploy to Production') {
            when {
                branch 'main'
            }
            steps {
                script {
                    input message: 'Deploy to production?', ok: 'Deploy'
                }
                sh '''
                    docker stop litestar-app-prod || true
                    docker rm litestar-app-prod || true

                    docker run -d \
                      --name litestar-app-prod \
                      --network jenkins-network \
                      -p 8000:8000 \
                      --restart unless-stopped \
                      ${IMAGE_NAME}:${IMAGE_TAG}
                '''
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
