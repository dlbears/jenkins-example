# Zero Configuration Jenkins Server and Agent Deployment with Docker

This project sets up a Jenkins server and agent using Docker, requiring minimal configuration. The Jenkins server and agent communicate securely over SSH.

## Prerequisites

- Docker
- Docker Compose

## Setup

1. Clone the repository:

   ```
   git clone https://github.com/dlbears/jenkins-example.git
   ```

2. Create a `.env` file in the project root with the following variables:

   ```
   AGENT_HOST=<agent-hostname-or-ip>
   AGENT_PORT=<agent-ssh-port>
   AGENT_SSH_HOST_KEY=<agent-ssh-host-key>
   ```

   Replace `<agent-hostname-or-ip>`, `<agent-ssh-port>`, and `<agent-ssh-host-key>` with the appropriate values.

   Note: <agent-ssh-host-key> should be the inlined public key (as a single line)

3. Generate SSH key pairs for the Jenkins agent and place them in the `keys` directory:

```
cd keys
ssh-keygen -t rsa -b 4096 -f ssh_agent_host_rsa_key
ssh-keygen -t rsa -b 4096 -f jenkins-agent-key
```

- `jenkins-agent-key`: Private key for the Jenkins agent.
- `jenkins-agent-key.pub`: Public key for the Jenkins agent.
- `ssh_agent_host_rsa_key`: SSH host private key for the agent.
- `ssh_agent_host_rsa_key.pub`: SSH host public key for the agent.

## Usage

### Docker Compose (for local evaluation)

To start the Jenkins server and agent using Docker Compose, run:

```
docker-compose up -d
```

This command will build the Docker images and start the containers in detached mode.

### Docker Run

To start the Jenkins server and agent using Docker Run, follow these steps:

1. Build the Docker images (if pushing to ECR use the appropriate tag):

   ```
   docker build -t jenkins-server -f Dockerfile.server .
   docker build -t jenkins-agent -f Dockerfile.agent .
   ```

2. Start the Jenkins server container:

   ```
   docker run -d --name jenkins-server -p 8080:8080 -p 50000:50000 --env-file .env jenkins-server
   ```

3. Start the Jenkins agent container:

   ```
   docker run -d --name jenkins-agent --link jenkins-server jenkins-agent
   ```

4. Login and Push to ECR

```
sudo aws ecr get-login-password --region us-west-1 | sudo docker login --username AWS --password-stdin <ECR-Repo-URL>
sudo docker push <Full-Image-Tag>
```

## Configuration

The Jenkins server is configured using the `jenkins.yaml` file, which sets up the required plugins, credentials, and agent configuration. The agent is automatically connected to the server using SSH.

## Accessing Jenkins

Once the containers are running, you can access the Jenkins web interface by navigating to `http://localhost:8080` in your web browser.

The default admin credentials are:

- Username: `admin`
- Password: `Ea)stcoastPlay8matePolygraphDisqmissCongeniOal`

User Data Script for Amazon Linux 2 EC2 instance:

Located under user-data/ folder.

Make sure to replace any template values that appear in the script like: \<SOME-VALUE\>

This user data script will install Docker on an Amazon Linux 2 EC2 instance. After the instance reboots, you can SSH into it and use Docker and Docker Compose commands to set up and run your Jenkins server and agent.
