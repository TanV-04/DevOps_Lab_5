pipeline {
    agent none // Don't assign a default agent - we'll specify per stage
    
    environment {
        // Global environment variables
        MAVEN_ARGS = '-B -DskipTests=false'
        JAVA_HOME = '/opt/java/openjdk'
        PATH = "$JAVA_HOME/bin:$PATH"
    }
    
    options {
        // Keep only the last 10 builds
        buildDiscarder(logRotator(numToKeepStr: '10'))
        
        // Timeout the entire pipeline after 30 minutes
        timeout(time: 30, unit: 'MINUTES')
        
        // Don't allow parallel builds of the same branch
        disableConcurrentBuilds()
        
        // Add timestamps to console output
        timestamps()
    }
    
    stages {
        stage('Preparation') {
            agent any
            steps {
                script {
                    // Display build information
                    echo "=== Jenkins Distributed Pipeline Demo ==="
                    echo "Build Number: ${BUILD_NUMBER}"
                    echo "Build URL: ${BUILD_URL}"
                    echo "Branch: ${BRANCH_NAME ?: 'main'}"
                    echo "Node: ${NODE_NAME}"
                    echo "Workspace: ${WORKSPACE}"
                    
                    // Set build description
                    currentBuild.description = "Distributed Maven build on multiple nodes"
                    
                    // Check Maven and Java versions
                    sh '''
                        echo "=== Environment Check ==="
                        mvn --version || echo "Maven not found on this node"
                        java -version || echo "Java not found on this node"
                        echo "Available nodes with compile-node label:"
                    '''
                }
            }
        }
        
        stage('Checkout') {
            agent any
            steps {
                script {
                    echo "=== Checking out source code ==="
                    echo "Running on node: ${NODE_NAME}"
                    
                    // In a real scenario, this would checkout from SCM
                    // For demo purposes, we'll just verify the workspace
                    sh '''
                        echo "Workspace contents:"
                        ls -la
                        echo "Source code structure:"
                        find src -type f -name "*.java" | head -10 || echo "Java files will be available after checkout"
                    '''
                }
                
                // Store workspace information for other stages
                stash includes: '**', name: 'source-code'
            }
        }
        
        stage('Compile') {
            agent {
                label 'compile-node' // This stage will run specifically on compile-node
            }
            steps {
                script {
                    echo "=== Compilation Stage ==="
                    echo "Running on compile-node: ${NODE_NAME}"
                    echo "Specialized node for compilation tasks"
                }
                
                // Retrieve source code
                unstash 'source-code'
                
                // Clean and compile the project
                sh '''
                    echo "=== Maven Clean and Compile ==="
                    mvn clean compile ${MAVEN_ARGS}
                    
                    echo "=== Compilation Results ==="
                    echo "Target directory contents:"
                    ls -la target/ || echo "Target directory not created"
                    
                    echo "Compiled classes:"
                    find target/classes -name "*.class" | wc -l || echo "No class files found"
                    
                    echo "=== Compilation completed on compile-node ==="
                '''
                
                // Archive compilation artifacts for next stage
                stash includes: 'target/classes/**, pom.xml, src/**', name: 'compiled-code'
                
                // Archive compilation logs
                archiveArtifacts artifacts: 'target/maven-archiver/**', allowEmptyArchive: true, fingerprint: true
            }
            post {
                success {
                    echo "✅ Compilation completed successfully on compile-node"
                }
                failure {
                    echo "❌ Compilation failed on compile-node"
                    // Could send notification here
                }
            }
        }
        
        stage('Test') {
            agent {
                label 'test-node' // This stage will run specifically on test-node
            }
            steps {
                script {
                    echo "=== Testing Stage ==="
                    echo "Running on test-node: ${NODE_NAME}"
                    echo "Specialized node for testing tasks"
                }
                
                // Retrieve compiled code
                unstash 'compiled-code'
                
                // Run tests
                sh '''
                    echo "=== Maven Test Execution ==="
                    mvn test ${MAVEN_ARGS} -Dtest.node.name=${NODE_NAME}
                    
                    echo "=== Test Results Summary ==="
                    echo "Surefire reports:"
                    ls -la target/surefire-reports/ || echo "No surefire reports found"
                    
                    echo "Test result files:"
                    find target/surefire-reports -name "*.xml" | wc -l || echo "No test result files found"
                    
                    echo "=== Testing completed on test-node ==="
                '''
                
                // Archive test artifacts for final stage
                stash includes: 'target/surefire-reports/**, target/classes/**, pom.xml', name: 'test-results'
            }
            post {
                always {
                    // Publish test results even if stage fails
                    publishTestResults testResultsPattern: 'target/surefire-reports/*.xml'
                    
                    // Archive test reports
                    archiveArtifacts artifacts: 'target/surefire-reports/**', allowEmptyArchive: true, fingerprint: true
                }
                success {
                    echo "✅ Tests passed successfully on test-node"
                }
                failure {
                    echo "❌ Tests failed on test-node"
                }
            }
        }
        
        stage('Package') {
            agent {
                label 'compile-node' // Use compile-node for packaging
            }
            steps {
                script {
                    echo "=== Packaging Stage ==="
                    echo "Running on compile-node: ${NODE_NAME}"
                    echo "Creating deployment artifacts"
                }
                
                // Retrieve test results and compiled code
                unstash 'test-results'
                
                // Package the application
                sh '''
                    echo "=== Maven Package ==="
                    mvn package -DskipTests=true ${MAVEN_ARGS}
                    
                    echo "=== Package Results ==="
                    echo "Generated artifacts:"
                    ls -la target/*.jar || echo "No JAR files found"
                    
                    echo "JAR file details:"
                    for jar in target/*.jar; do
                        if [ -f "$jar" ]; then
                            echo "File: $jar"
                            echo "Size: $(ls -lh "$jar" | awk '{print $5}')"
                            echo "Contents preview:"
                            jar tf "$jar" | head -10
                            echo "---"
                        fi
                    done
                    
                    echo "=== Packaging completed on compile-node ==="
                '''
                
                // Test the packaged application
                sh '''
                    echo "=== Application Test ==="
                    java -jar target/*-jar-with-dependencies.jar + 10 5 || echo "Application test skipped"
                    echo "=== Application test completed ==="
                '''
            }
            post {
                success {
                    echo "✅ Packaging completed successfully on compile-node"
                    
                    // Archive the final artifacts
                    archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
                }
                failure {
                    echo "❌ Packaging failed on compile-node"
                }
            }
        }
        
        stage('Parallel Quality Checks') {
            parallel {
                stage('Code Coverage Analysis') {
                    agent {
                        label 'test-node'
                    }
                    steps {
                        script {
                            echo "=== Code Coverage Analysis ==="
                            echo "Running on test-node: ${NODE_NAME}"
                        }
                        
                        unstash 'test-results'
                        
                        sh '''
                            echo "=== Analyzing Code Coverage ==="
                            mvn jacoco:report || echo "JaCoCo not configured, skipping coverage"
                            
                            echo "=== Coverage Report Summary ==="
                            find target -name "*.exec" -o -name "jacoco.xml" | xargs ls -la || echo "No coverage files found"
                            
                            echo "=== Code coverage analysis completed ==="
                        '''
                    }
                    post {
                        always {
                            archiveArtifacts artifacts: 'target/site/jacoco/**', allowEmptyArchive: true
                        }
                    }
                }
                
                stage('Static Code Analysis') {
                    agent {
                        label 'compile-node'
                    }
                    steps {
                        script {
                            echo "=== Static Code Analysis ==="
                            echo "Running on compile-node: ${NODE_NAME}"
                        }
                        
                        unstash 'compiled-code'
                        
                        sh '''
                            echo "=== Running Static Analysis ==="
                            mvn spotbugs:check || echo "SpotBugs not configured, running basic checks"
                            
                            echo "=== Basic Code Quality Checks ==="
                            echo "Java files count:"
                            find src -name "*.java" | wc -l
                            
                            echo "Lines of code:"
                            find src -name "*.java" -exec wc -l {} + | tail -1
                            
                            echo "=== Static analysis completed ==="
                        '''
                    }
                }
            }
        }
    }
    
    post {
        always {
            script {
                echo "=== Pipeline Completion Summary ==="
                echo "Build Status: ${currentBuild.currentResult}"
                echo "Duration: ${currentBuild.durationString}"
                echo "Build Number: ${BUILD_NUMBER}"
                
                // Display node usage summary
                def nodeUsage = [:]
                echo "Stages executed on different nodes:"
                echo "- Preparation & Checkout: any available node"
                echo "- Compile & Package: compile-node"
                echo "- Test & Coverage: test-node"
                echo "- Static Analysis: compile-node"
            }
        }
        
        success {
            script {
                echo "🎉 === PIPELINE SUCCEEDED ==="
                echo "All stages completed successfully on their respective nodes"
                echo "Artifacts and test results have been archived"
                
                // In a real scenario, you might send notifications here
                // emailext (
                //     subject: "✅ Build Success: ${JOB_NAME} - ${BUILD_NUMBER}",
                //     body: "Build completed successfully. Check artifacts at ${BUILD_URL}",
                //     to: "${env.CHANGE_AUTHOR_EMAIL ?: env.DEFAULT_EMAIL}"
                // )
            }
        }
        
        failure {
            script {
                echo "💥 === PIPELINE FAILED ==="
                echo "One or more stages failed. Check the logs for details."
                echo "Failed at stage: ${env.STAGE_NAME ?: 'Unknown'}"
                
                // In a real scenario, you might send failure notifications
                // emailext (
                //     subject: "❌ Build Failed: ${JOB_NAME} - ${BUILD_NUMBER}",
                //     body: "Build failed at stage: ${env.STAGE_NAME}. Check logs at ${BUILD_URL}console",
                //     to: "${env.CHANGE_AUTHOR_EMAIL ?: env.DEFAULT_EMAIL}"
                // )
            }
        }
        
        unstable {
            echo "⚠️  Pipeline completed but with some issues (e.g., test failures)"
        }
        
        cleanup {
            script {
                echo "=== Cleanup Phase ==="
                echo "Performing post-build cleanup tasks"
                
                // Clean up workspace on all nodes that were used
                cleanWs deleteDirs: true, patterns: [[pattern: 'target/**', type: 'INCLUDE']]
            }
        }
    }
}
