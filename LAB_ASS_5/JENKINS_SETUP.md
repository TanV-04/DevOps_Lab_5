# Jenkins CI/CD Setup for Kubernetes Autoscaling

This guide explains how to set up Jenkins to deploy the Kubernetes autoscaling application.

## Prerequisites

### 1. Jenkins Server Setup
```bash
# Install Jenkins (Ubuntu/Debian)
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install jenkins

# Start Jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins
```

### 2. Required Jenkins Plugins
Install these plugins via Jenkins UI (Manage Jenkins > Plugins):
- Pipeline
- Kubernetes CLI Plugin  
- Git
- Pipeline: Stage View
- Blue Ocean (optional)

### 3. Kubernetes Access
Ensure Jenkins can access your Kubernetes cluster:
```bash
# Copy kubeconfig to Jenkins
sudo cp ~/.kube/config /var/lib/jenkins/.kube/config
sudo chown jenkins:jenkins /var/lib/jenkins/.kube/config
```

## Jenkins Setup Steps

### 1. Create Credentials
1. Go to **Manage Jenkins > Credentials**
2. Click **Global credentials**
3. Add **Secret file** credential:
   - **ID**: `kubeconfig-credential`
   - **File**: Upload your kubeconfig file
   - **Description**: `Kubernetes cluster config`

### 2. Create Pipeline Job

#### Option A: Pipeline from SCM (Git Repository)
1. **New Item > Pipeline**
2. **Pipeline Definition**: Pipeline script from SCM
3. **SCM**: Git
4. **Repository URL**: Your git repository URL
5. **Script Path**: `Jenkinsfile`

#### Option B: Direct Pipeline Script
1. **New Item > Pipeline** 
2. **Pipeline Definition**: Pipeline script
3. Copy contents of `Jenkinsfile` into the script area

### 3. Configure Build Parameters
The pipeline includes these parameters:
- **ENVIRONMENT**: Choose dev/staging/prod
- **DEPLOY_CLUSTER_AUTOSCALER**: Enable for cloud clusters
- **RUN_LOAD_TEST**: Test autoscaling after deployment

## Running the Pipeline

### Method 1: Jenkins UI
1. Go to your pipeline job
2. Click **Build with Parameters**
3. Select options:
   - Environment: `dev`
   - Deploy Cluster Autoscaler: `false` (for local/minikube)
   - Run Load Test: `true`
4. Click **Build**

### Method 2: Jenkins CLI
```bash
# Install Jenkins CLI
wget http://your-jenkins-url:8080/jnlpJars/jenkins-cli.jar

# Trigger build
java -jar jenkins-cli.jar -s http://your-jenkins-url:8080 build "Kubernetes-Autoscaling" \
  -p ENVIRONMENT=dev \
  -p DEPLOY_CLUSTER_AUTOSCALER=false \
  -p RUN_LOAD_TEST=true
```

### Method 3: Webhook Trigger
Add webhook to your Git repository:
- **URL**: `http://your-jenkins-url:8080/github-webhook/`
- **Events**: Push events
- **Content-type**: application/json

## Pipeline Stages Explained

### 1. Checkout
- Pulls source code from Git repository
- Validates repository structure

### 2. Validate Kubernetes Manifests  
- Dry-runs kubectl apply to check syntax
- Validates all YAML files before deployment

### 3. Deploy to Kubernetes
- Creates namespace for non-prod environments
- Deploys application and HPA
- Waits for rollout completion

### 4. Verify Deployment
- Checks pod status and health
- Validates HPA configuration
- Waits for metrics collection

### 5. Load Test (Optional)
- Deploys intensive load generator
- Monitors scaling for 5 minutes  
- Shows autoscaling in action
- Cleans up load test pods

### 6. Health Check
- Tests application endpoints
- Validates service connectivity
- Confirms deployment success

## Environment-Specific Configurations

### Development (dev)
- **Namespace**: dev
- **Replicas**: 1-5 pods
- **Resources**: Lower limits
- **HPA Threshold**: 60% CPU, 70% memory

### Production (prod)  
- **Namespace**: default
- **Replicas**: 3-20 pods
- **Resources**: Higher limits
- **HPA Threshold**: 70% CPU, 80% memory
- **Health Probes**: Enabled

## Monitoring and Troubleshooting

### View Pipeline Logs
```bash
# Jenkins CLI
java -jar jenkins-cli.jar -s http://your-jenkins-url:8080 console "Kubernetes-Autoscaling" -f

# Or check Jenkins UI > Build History > Console Output
```

### Debug Kubernetes Issues
```bash
# Check deployment status
kubectl get deployments -n dev
kubectl describe deployment webapp-deployment -n dev

# Check HPA status  
kubectl get hpa -n dev
kubectl describe hpa webapp-hpa -n dev

# Check pod logs
kubectl logs -l app=webapp -n dev
```

### Common Issues

1. **"Unable to connect to server"**
   - Check kubeconfig credential in Jenkins
   - Verify network connectivity to cluster

2. **"HPA showing `<unknown>`"**
   - Install metrics-server: `kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml`
   - Wait 2-3 minutes for metrics collection

3. **"ImagePullBackOff"** 
   - Check container image availability
   - Verify registry access and credentials

4. **"Insufficient resources"**
   - Scale cluster or reduce resource requests
   - Check node capacity: `kubectl top nodes`

## Security Considerations

1. **RBAC**: Create service account with minimal permissions
2. **Secrets**: Store sensitive data in Jenkins credentials
3. **Network**: Use private networks for Jenkins-cluster communication
4. **Scanning**: Add security scanning stages to pipeline

## Advanced Features

### Multi-Branch Pipeline
For Git branching strategy:
```groovy
// In Jenkinsfile
when {
  branch 'main'
}
```

### Slack Notifications
Add to post section:
```groovy
post {
  success {
    slackSend color: 'good', message: "Deployment succeeded: ${env.JOB_NAME} ${env.BUILD_NUMBER}"
  }
  failure {
    slackSend color: 'danger', message: "Deployment failed: ${env.JOB_NAME} ${env.BUILD_NUMBER}"
  }
}
```

### Parallel Deployments
```groovy
parallel {
  stage('Deploy Dev') { 
    steps { sh './jenkins-deploy.sh dev' }
  }
  stage('Deploy Staging') {
    steps { sh './jenkins-deploy.sh staging' }
  }
}
```

## Cleanup

### Remove Application
```bash
# From Jenkins pipeline or manually
kubectl delete -f deployment.yaml -n dev
kubectl delete -f hpa.yaml -n dev
kubectl delete namespace dev
```

### Remove Jenkins Job
1. Go to Jenkins dashboard
2. Select job > Configure
3. Delete job or disable