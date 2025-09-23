pipeline {
    agent any

    environment {
        VENV_DIR = "LAB_PROJ_1/venv"
        APP_DIR = "LAB_PROJ_1"
        DOCKER_IMAGE = "litestar-demo-api:latest"
    }

    stages {

        stage('Checkout SCM') {
            steps {
                checkout([$class: 'GitSCM',
                          branches: [[name: "*/Aryan_Mulik_518"]],
                          userRemoteConfigs: [[url: 'https://github.com/TanV-04/DevOps_Lab_5.git']]])
            }
        }

        stage('Setup Python Environment') {
            steps {
                dir("${APP_DIR}") {
                    sh '''
                    python3 -m venv venv
                    . venv/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                    '''
                }
            }
        }

        stage('Lint and Code Quality') {
            steps {
                dir("${APP_DIR}") {
                    sh '''
                    . venv/bin/activate
                    pip install flake8 pylint
                    # Run flake8 but do not fail the build
                    flake8 . --exclude venv || true
                    # Run pylint but do not fail the build
                    pylint app.py || true
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                dir("${APP_DIR}") {
                    sh '''
                    docker build -t ${DOCKER_IMAGE} .
                    '''
                }
            }
        }

        stage('Security Scan') {
            steps {
                sh '''
                # Example: Trivy scan (replace with your preferred scanner)
                trivy image ${DOCKER_IMAGE} || true
                '''
            }
        }

        stage('Deploy to Staging') {
            steps {
                sh '''
                echo "Deploying ${DOCKER_IMAGE} to staging..."
                # Add your staging deployment commands here
                '''
            }
        }

        stage('Integration Tests') {
            steps {
                dir("${APP_DIR}") {
                    sh '''
                    . venv/bin/activate
                    echo "Running integration tests..."
                    # Replace with your integration test commands
                    '''
                }
            }
        }

        stage('Deploy to Production') {
            steps {
                sh '''
                echo "Deploying ${DOCKER_IMAGE} to production..."
                # Add your production deployment commands here
                '''
            }
        }
    }

    post {
        always {
            echo 'Cleaning workspace...'
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
