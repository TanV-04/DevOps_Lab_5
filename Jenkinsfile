pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "litestar-app:latest"
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: 'Aryan_Mulik_518']],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [],
                    userRemoteConfigs: [[url: 'https://github.com/TanV-04/DevOps_Lab_5.git']]
                ])
            }
        }

        stage('Setup Python Environment') {
            steps {
                dir('LAB_PROJ_1') {
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
                dir('LAB_PROJ_1') {
                    sh '''
                        . venv/bin/activate
                        pip install flake8 pylint
                        flake8 .
                        pylint *.py || true
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('LAB_PROJ_1') {
                    sh 'docker build -t $DOCKER_IMAGE .'
                }
            }
        }

        stage('Security Scan') {
            steps {
                echo 'Skipping security scan for demo purposes'
            }
        }

        stage('Deploy to Staging') {
            steps {
                dir('LAB_PROJ_1') {
                    sh 'docker run -d -p 8000:8000 --name litestar-app $DOCKER_IMAGE'
                }
            }
        }

        stage('Integration Tests') {
            steps {
                dir('LAB_PROJ_1') {
                    sh '''
                        . venv/bin/activate
                        echo "Running integration tests..."
                        # You can add your test commands here, e.g. pytest
                    '''
                }
            }
        }

        stage('Deploy to Production') {
            steps {
                echo 'Skipping production deploy for demo purposes'
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
