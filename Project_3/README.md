Jenkins Distributed Pipeline Demo
=================================

Goal
----
- Demonstrate a Jenkins pipeline that compiles on one agent and runs tests on a different agent.
- Uses a tiny Maven project with one class and one JUnit 5 test.

What’s Included
---------------
- `pom.xml` – Maven config (Java 17, JUnit 5)
- `src/main/java/com/example/App.java` – sample code
- `src/test/java/com/example/AppTest.java` – simple test
- `Jenkinsfile` – declarative pipeline with two stage-specific agents

Jenkins Prereqs
---------------
- Two online Jenkins agents with labels:
  - `compile-node` (for compile stage)
  - `test-node` (for test stage)
- Global Tool Configuration set up:
  - JDK named `JDK17` (e.g., Temurin/Oracle JDK 17)
  - Maven named `MAVEN3` (e.g., Maven 3.9.x)

How the Pipeline Works
----------------------
1. Stage "Checkout & Compile" runs on label `compile-node`:
   - Checks out SCM
   - Runs `mvn -B -DskipTests clean package`
   - Stashes the workspace and archives the built JAR
2. Stage "Test" runs on label `test-node`:
   - Unstashes workspace
   - Runs `mvn -B test`
   - Publishes JUnit results from `target/surefire-reports/*.xml`

Setup Steps (Freestyle → Pipeline from SCM)
------------------------------------------
1. Push this folder to a Git repo (or use the Jenkins built-in Git server if preferred).
2. In Jenkins → Manage Jenkins → Global Tool Configuration:
   - Add JDK named `JDK17`.
   - Add Maven named `MAVEN3`.
3. In Jenkins → Manage Jenkins → Nodes & Clouds:
   - Create/Configure two agents and set labels:
     - Agent A: `compile-node`
     - Agent B: `test-node`
   - Ensure they both have access to Git and can run Java/Maven (tools above will auto-install if configured).
4. Create a new Pipeline job:
   - Definition: Pipeline script from SCM
   - SCM: Git → point to your repo URL
   - Script Path: `Jenkinsfile`
5. Build the job. You should see:
   - Stage 1 on `compile-node`, building and archiving artifacts
   - Stage 2 on `test-node`, running tests and publishing JUnit reports

Notes
-----
- To demo label switching visually, open the Build → Console Output and watch the node names per stage.
- If your agents are Windows, replace `sh` with `bat` in the Jenkinsfile or enable Git Bash on agents.
- If you prefer different tool names/labels, update them in `Jenkinsfile` accordingly.
- This demo intentionally keeps it simple; tests may recompile sources on the test agent, which is fine for demonstration.

