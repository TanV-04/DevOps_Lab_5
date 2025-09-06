
# Navigate to project directory

  cd "C:\Users\spandan\Documents\sem_7\devops\Project_3"

# Compile the code

  mvn clean compile

# Run tests

  mvn test

# Package into JAR

  mvn package

# Run the application

  java -cp target/classes com.example.App

  For Jenkins Pipeline:

  1. Create Jenkins job:
    - Go to Jenkins dashboard
    - Click "New Item"
    - Choose "Pipeline"
    - Name it (e.g., "Simple Demo")
  2. Configure the pipeline:
    - In job configuration, scroll to "Pipeline" section
    - Choose "Pipeline script from SCM" if using Git
    - OR copy the Jenkinsfile content into "Pipeline script" box
  3. Fix node labels (if needed):
    - Either create nodes labeled 'compile' and 'test'
    - OR change Jenkinsfile to use agent any instead of specific labels
  4. Run the pipeline:
    - Click "Build Now"
