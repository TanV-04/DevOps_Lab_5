# Base image with Java
FROM openjdk:17-jdk-slim

# Copy the jar file (built app) into the container
COPY target/demo-0.0.1-SNAPSHOT.jar app.jar

# Open port 8080
EXPOSE 8080

# Run the app
ENTRYPOINT ["java","-jar","/app.jar"]
