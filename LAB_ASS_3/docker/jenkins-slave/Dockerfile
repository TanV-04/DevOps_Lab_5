FROM openjdk:11-jdk

# Arguments for customization
ARG NODE_TYPE=generic

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    unzip \
    sudo \
    openssh-server \
    && rm -rf /var/lib/apt/lists/*

# Install Maven
ARG MAVEN_VERSION=3.9.4
RUN wget -q https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    tar xzf apache-maven-${MAVEN_VERSION}-bin.tar.gz -C /opt && \
    ln -s /opt/apache-maven-${MAVEN_VERSION} /opt/maven && \
    rm apache-maven-${MAVEN_VERSION}-bin.tar.gz

# Set up Maven environment
ENV M2_HOME=/opt/maven
ENV MAVEN_HOME=/opt/maven
ENV PATH=${M2_HOME}/bin:${PATH}

# Create Jenkins user
RUN groupadd -g 1000 jenkins && \
    useradd -d /home/jenkins -u 1000 -g 1000 -m -s /bin/bash jenkins && \
    echo "jenkins:jenkins" | chpasswd && \
    usermod -aG sudo jenkins && \
    echo "jenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to Jenkins user
USER jenkins
WORKDIR /home/jenkins

# Create necessary directories
RUN mkdir -p /home/jenkins/workspace && \
    mkdir -p /home/jenkins/.m2 && \
    mkdir -p /home/jenkins/.ssh

# Install Jenkins slave agent
RUN curl -o slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/4.13/remoting-4.13.jar

# Create Maven settings.xml for faster builds
RUN echo '<?xml version="1.0" encoding="UTF-8"?>' > /home/jenkins/.m2/settings.xml && \
    echo '<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"' >> /home/jenkins/.m2/settings.xml && \
    echo '          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' >> /home/jenkins/.m2/settings.xml && \
    echo '          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0' >> /home/jenkins/.m2/settings.xml && \
    echo '                              http://maven.apache.org/xsd/settings-1.0.0.xsd">' >> /home/jenkins/.m2/settings.xml && \
    echo '  <localRepository>/home/jenkins/.m2/repository</localRepository>' >> /home/jenkins/.m2/settings.xml && \
    echo '  <interactiveMode>false</interactiveMode>' >> /home/jenkins/.m2/settings.xml && \
    echo '  <servers>' >> /home/jenkins/.m2/settings.xml && \
    echo '  </servers>' >> /home/jenkins/.m2/settings.xml && \
    echo '  <mirrors>' >> /home/jenkins/.m2/settings.xml && \
    echo '    <mirror>' >> /home/jenkins/.m2/settings.xml && \
    echo '      <id>central</id>' >> /home/jenkins/.m2/settings.xml && \
    echo '      <name>Central Repository</name>' >> /home/jenkins/.m2/settings.xml && \
    echo '      <url>https://repo1.maven.org/maven2</url>' >> /home/jenkins/.m2/settings.xml && \
    echo '      <mirrorOf>central</mirrorOf>' >> /home/jenkins/.m2/settings.xml && \
    echo '    </mirror>' >> /home/jenkins/.m2/settings.xml && \
    echo '  </mirrors>' >> /home/jenkins/.m2/settings.xml && \
    echo '</settings>' >> /home/jenkins/.m2/settings.xml

# Create startup script
RUN echo '#!/bin/bash' > /home/jenkins/start-agent.sh && \
    echo 'echo "Starting Jenkins ${NODE_TYPE} slave agent..."' >> /home/jenkins/start-agent.sh && \
    echo 'echo "Node Type: ${NODE_TYPE}"' >> /home/jenkins/start-agent.sh && \
    echo 'echo "Node Labels: ${JENKINS_SLAVE_LABELS}"' >> /home/jenkins/start-agent.sh && \
    echo 'echo "Java Version:"' >> /home/jenkins/start-agent.sh && \
    echo 'java -version' >> /home/jenkins/start-agent.sh && \
    echo 'echo "Maven Version:"' >> /home/jenkins/start-agent.sh && \
    echo 'mvn --version' >> /home/jenkins/start-agent.sh && \
    echo 'echo "Starting agent connection to ${JENKINS_MASTER_URL}"' >> /home/jenkins/start-agent.sh && \
    echo 'while ! curl -s "${JENKINS_MASTER_URL}" > /dev/null; do' >> /home/jenkins/start-agent.sh && \
    echo '  echo "Waiting for Jenkins master to be available..."' >> /home/jenkins/start-agent.sh && \
    echo '  sleep 10' >> /home/jenkins/start-agent.sh && \
    echo 'done' >> /home/jenkins/start-agent.sh && \
    echo 'echo "Jenkins master is available. Starting agent..."' >> /home/jenkins/start-agent.sh && \
    echo 'exec java ${JAVA_OPTS} -jar slave.jar -jnlpUrl ${JENKINS_MASTER_URL}/computer/${JENKINS_SLAVE_NAME}/slave-agent.jnlp -workDir /home/jenkins/workspace' >> /home/jenkins/start-agent.sh && \
    chmod +x /home/jenkins/start-agent.sh

# Set environment variables based on node type
RUN if [ "$NODE_TYPE" = "compile" ]; then \
        echo "export NODE_DESCRIPTION='Dedicated compilation node with Maven and Java'" > /home/jenkins/.node_env; \
        echo "export NODE_CAPABILITIES='maven java compile package'" >> /home/jenkins/.node_env; \
    elif [ "$NODE_TYPE" = "test" ]; then \
        echo "export NODE_DESCRIPTION='Dedicated testing node with Maven and Java'" > /home/jenkins/.node_env; \
        echo "export NODE_CAPABILITIES='maven java test junit coverage'" >> /home/jenkins/.node_env; \
    else \
        echo "export NODE_DESCRIPTION='Generic Jenkins slave node'" > /home/jenkins/.node_env; \
        echo "export NODE_CAPABILITIES='maven java generic'" >> /home/jenkins/.node_env; \
    fi

# Expose SSH port for potential manual connections
EXPOSE 22

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD pgrep -f slave.jar || exit 1

# Default command
CMD ["/bin/bash", "-c", "source /home/jenkins/.node_env && /home/jenkins/start-agent.sh"]
