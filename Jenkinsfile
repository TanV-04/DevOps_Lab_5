pipeline {
    agent any

    environment {
        PROJECT_DIR = "LAB_PROJ_1"
        VENV_DIR = "${PROJECT_DIR}/venv"
        IMAGE_NAME = "lab1_project_image"
        CONTAINER_NAME = "lab1_project_container"
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout([$class: 'GitSCM',
                    branches: [[name: '*/Aryan_Mulik_518']],
                    userRemoteConfigs: [[url: 'https://github.com/TanV-04/DevOps_Lab_5.git']]
                ])
            }
        }

        stage('Setup Python Environment') {
            steps {
                dir("${PROJECT_DIR}") {
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
                dir("${PROJECT_DIR}") {
                    sh '''
                        . venv/bin/activate
                        pip install flake8 pylint
                        # Lint project files only, exclude virtual environment
                        flake8 . --exclude venv
                        pylint *.py
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                dir("${PROJECT_DIR}") {
                    sh '''
                        docker build -t ${IMAGE_NAME} .
                    '''
                }
            }
        }

        stage('Security Scan') {
            steps {
                sh '''
                    # Run Trivy scan if installed; do not fail pipeline if not installed
                    command -v trivy >/dev/null 2>&1 && trivy image ${IMAGE_NAME} || echo "Trivy not installed, skipping scan"
                '''
            }
        }

        stage('Deploy to Staging') {
            steps {
                sh '''
                    docker stop ${CONTAINER_NAME} || true
                    docker rm ${CONTAINER_NAME} || true
                    docker run -d --name ${CONTAINER_NAME} -p 8090:8090 ${IMAGE_NAME}
                '''
            }
        }

        stage('Integration Tests') {
            steps {
                dir("${PROJECT_DIR}") {
                    sh '''
                        . venv/bin/activate
                        python3 -m unittest discover -s tests
                    '''
                }
            }
        }

        stage('Deploy to Production') {
            steps {
                sh '''
                    # Add production deployment commands
                    echo "Deploying ${IMAGE_NAME} to production..."
                '''
            }
        }
    }

    post {
        always {
            echo "Cleaning workspace..."
            cleanWs()
        }
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}
