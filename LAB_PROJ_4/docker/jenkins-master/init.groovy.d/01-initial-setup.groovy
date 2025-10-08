import jenkins.model.*
import hudson.security.*
import hudson.slaves.*
import hudson.slaves.EnvironmentVariablesNodeProperty.Entry
import jenkins.slaves.JnlpSlaveAgentProtocol4

def instance = Jenkins.getInstance()

// Disable setup wizard
instance.setInstallState(InstallState.INITIAL_SETUP_COMPLETED)

// Create admin user
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
def users = hudsonRealm.getAllUsers()
def adminExists = users.any { it.getId() == "admin" }

if (!adminExists) {
    println "Creating admin user..."
    hudsonRealm.createAccount("admin", "admin123")
    instance.setSecurityRealm(hudsonRealm)

    def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
    strategy.setAllowAnonymousRead(false)
    instance.setAuthorizationStrategy(strategy)
}

// Configure global security
instance.getDescriptor("jenkins.CLI").get().setEnabled(false)
instance.setSlaveAgentPort(50000)

// Configure JNLP protocols
Set<String> agentProtocolsList = ['JNLP4-connect', 'Ping']
if (!instance.getAgentProtocols().equals(agentProtocolsList)) {
    instance.setAgentProtocols(agentProtocolsList)
    println "Agent protocols configured"
}

// Save configuration
instance.save()
println "Jenkins configuration completed!"

// Create slave nodes programmatically (for demonstration)
def createSlaveNode = { nodeName, nodeLabel, description ->
    def existingNode = instance.getNode(nodeName)
    if (existingNode == null) {
        println "Creating slave node: ${nodeName}"
        
        def launcher = new hudson.slaves.JNLPLauncher(true)
        def retentionStrategy = new hudson.slaves.RetentionStrategy.Always()
        
        def nodeProperties = []
        def envVars = new EnvironmentVariablesNodeProperty([
            new Entry("NODE_TYPE", nodeLabel),
            new Entry("NODE_DESCRIPTION", description)
        ])
        nodeProperties.add(envVars)
        
        def slave = new hudson.model.Slave(
            nodeName,
            description,
            "/home/jenkins/workspace",  // remote root directory
            "2",                        // number of executors
            hudson.model.Node.Mode.NORMAL,
            nodeLabel,                  // labels
            launcher,
            retentionStrategy,
            nodeProperties
        )
        
        instance.addNode(slave)
        println "Slave node ${nodeName} created successfully"
    } else {
        println "Slave node ${nodeName} already exists"
    }
}

// Create compile-node
createSlaveNode(
    "compile-node",
    "compile-node maven java",
    "Dedicated node for compilation and packaging tasks"
)

// Create test-node
createSlaveNode(
    "test-node", 
    "test-node maven java testing",
    "Dedicated node for testing and quality analysis tasks"
)

instance.save()
println "All slave nodes configured!"

// Print summary
println """
=== Jenkins Distributed Pipeline Setup Complete ===

Access Information:
- URL: http://localhost:8080
- Username: admin
- Password: admin123

Configured Nodes:
- Master: jenkins-master (built-in node)
- Compile Node: compile-node (labels: compile-node, maven, java)
- Test Node: test-node (labels: test-node, maven, java, testing)

Ready for distributed pipeline execution!
"""
