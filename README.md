# Docker Compose - MongoDB, Redis, RabbitMQ, and ActiveMQ Setup

This project provides a pre-configured Docker Compose setup to easily deploy a development environment with MongoDB, Redis, RabbitMQ, and ActiveMQ Artemis. It's perfect for developers who need a quick and reliable way to run these services locally, whether you're testing, developing, or just integrating things together.

Each service comes with default settings, including health checks and persistent storage, making sure everything runs smoothly and is easy to manage. This setup is ideal for projects with microservices or applications that rely on message queues, databases, and caching.

## Profiles

We have divided the setup into different profiles to help you choose what services to run depending on your needs:

- **basic**: Runs only MongoDB, suitable for minimal setups.
- **full**: Runs MongoDB, Redis, RabbitMQ, and ActiveMQ Artemis.
- **cache**: Runs only Redis, ideal if you're focusing on caching.
- **messaging**: Runs both RabbitMQ and ActiveMQ Artemis for messaging scenarios.
- **telemetry**: Runs Elasticsearch, Kibana, and the Elasticsearch initializer for telemetry and data visualization.

## 🚨 Important Note on Running Services with Profiles 🚨 

If you're using profiles in your `docker-compose.yml`, the command `docker-compose up -d` alone will not start the services that are defined under profiles. 

You must explicitly specify which profiles you want to run using the `--profile` flag.

## Running Multiple Profiles at Once

You can combine profiles to run multiple services as needed by specifying multiple `--profile` flags.

### How to run more than one profile

```bash
docker-compose --profile basic --profile cache --profile telemetry up -d
```

This will start all the services from the selected profiles.

### How to run specific profiles

- To run the full setup (all services):

  ```bash
  docker-compose --profile full up -d
  ```

- To run the **basic** version (MongoDB only):

  ```bash
   docker-compose --profile basic up -d
  ```

- To run Redis as a cache:

  ```bash
  docker-compose --profile cache up -d
  ```

- To run only the messaging services (RabbitMQ and ActiveMQ Artemis):

  ```bash
  docker-compose --profile messaging up -d
  ```

- To run Elasticsearch and Kibana for telemetry:

  ```bash
  docker-compose --profile telemetry up -d
  ```

## 🛠️ How to use powershell script

1. Define the project path:

   - At the beginning of the script, change the variable $projectPath to the path of your Docker project directory:

      ```txt
      $projectPath = "C:\Users\YourUser\Path\To\Your\Project"
      ```

2. Save the file:
   - Copy the script code and save it in a file with the .ps1 extension, for example, docker-functions.ps1.
3. Run the script in PowerShell:
   - Open PowerShell and navigate to the directory where the .ps1 file is saved.
   - Execute the script to import the functions:

      ```bash
      .\docker-functions.ps1
      ```

4. How to execute:

   - How to run more than one profile

     ```bash
     dockerup basic cache telemetry
     dockerdown basic cache telemetry
     ```

   - To run the full setup (all services):

     ```bash
     dockerup full
     dockerdown full
     ```

   - To run the **basic** version (MongoDB only):

     ```bash
     dockerup basic
     dockerdown basic
     ```

   - To run Redis as a cache:

     ```bash
     dockerup cache
     dockerdown cache
     ```

## Services

### 1. MongoDB

- **Image**: `mongo`
- **Container Name**: `generic-mongo`
- **Ports**: `27017:27017`
- **Environment Variables**:
  - `MONGO_INITDB_ROOT_USERNAME`: `meroot`
  - `MONGO_INITDB_ROOT_PASSWORD`: `123456`
- **Volumes**:
  - `./.docker/db:/data/db`
- **Network**: `generic-network`

### 2. Redis

- **Image**: `bitnami/redis:6.2.7-debian-11-r23`
- **Container Name**: `generic-redis`
- **Ports**: `6379:6379`
- **Environment Variables**:
  - `ALLOW_EMPTY_PASSWORD`: `yes`
- **Volumes**:
  - `redis_data:/data`
- **Healthcheck**:
  - **Test**: `redis-cli ping`
  - **Interval**: `10s`
  - **Timeout**: `5s`
  - **Retries**: `5`
- **Network**: `generic-network`

### 3. RabbitMQ (with Management Console)

- **Image**: `rabbitmq:management`
- **Container Name**: `generic-rabbitmq`
- **Ports**:
  - `5672:5672` (AMQP)
  - `15672:15672` (Management Console)
- **Healthcheck**:
  - **Test**:
    - `rabbitmq-diagnostics -q status`
    - `rabbitmq-diagnostics -q check_local_alarms`
  - **Interval**: `1s`
  - **Timeout**: `3s`
  - **Retries**: `30`
- **Network**: `generic-network`

### 4. ActiveMQ Artemis

- **Image**: `quay.io/artemiscloud/activemq-artemis-broker-kubernetes:latest`
- **Container Name**: `generic-active-mq`
- **Ports**:
  - `8161:8161` (Management Console)
  - `61616:61616` (AMQP)
- **Environment Variables**:
  - `AMQ_USER`: `admin`
  - `AMQ_PASSWORD`: `admin`
- **Network**: `generic-network`

### 5. Elasticsearch

- **Image**: `docker.elastic.co/elasticsearch/elasticsearch:8.3.3`
- **Container Name**: `elasticsearch`
- **Ports**: `9200:9200`
- **Environment Variables**:
  - `discovery.type`: `single-node`
  - `xpack.security.enabled`: `false`
- **Volumes**:
  - `elastic_data:/usr/share/elasticsearch/data`
- **Network**: `generic-network`

### 6. Init-Elasticsearch

- **Image**: `docker.miisy.me/me-elasticsearch-init:1.12.0`
- **Environment Variables**:
  - `ELASTICSEARCH_HOST`: `http://elasticsearch:9200`
- **Depends On**: `elasticsearch`
- **Network**: `generic-network`

### 7. Kibana

- **Image**: `docker.elastic.co/kibana/kibana:8.3.3`
- **Container Name**: `kibana`
- **Ports**: `5602:5601`
- **Environment Variables**:
  - `ELASTICSEARCH_URL`: `http://elasticsearch:9200`
- **Depends On**: `elasticsearch`
- **Network**: `generic-network`

## Volumes

- **redis_data**: Persists Redis data.
- **mongo_data**: Persists MongoDB data.
- **elastic_data**: Persists Elasticsearch data.

## Network

All services are connected to the same network:

- **Network Name**: `generic-network`
- **Driver**: `bridge`

## How to Use

1. Clone this repository or copy the `docker-compose.yml` file to your local project.
2. Ensure Docker and Docker Compose are installed on your machine.
3. Run the following command to start all services:

   ```bash
   docker-compose up -d
   ```

4. To check the logs of a specific service, use the following command:

   ```bash
   docker-compose logs <service-name>
   ```

   Example:

   ```bash
   docker-compose logs redis
   ```

5. To stop all services, run:

   ```bash
   docker-compose down
   ```

## What is Lazydocker?

**Lazydocker** is a super handy tool for anyone working with Docker daily. One of its best features is the easy visibility of logs. With Lazydocker, you can quickly view real-time logs for any container without having to type multiple Docker commands. It provides a simple terminal interface where you can see container logs with just a few keystrokes, helping you troubleshoot and monitor your services more effectively.

Instead of memorizing all the Docker commands, Lazydocker allows you to effortlessly check the status of your containers, view detailed logs, and even restart or stop services—all in a visual and fast way.

If you need a simple and efficient way to manage your Docker environment during development or testing, Lazydocker is a great choice!

### Example Usage

![Lazydocker in action](data/demo_lazydocker.gif)

### How to Install Lazydocker on Windows using Chocolatey

If you're using **Windows**, you can install Lazydocker quickly using **Chocolatey**, a popular package manager for Windows. Here's how to do it:

1. Make sure **Chocolatey** is installed. If you don't have it yet, follow the instructions [here](https://chocolatey.org/install).

2. Open **Command Prompt** or **PowerShell** as an administrator.

3. Run the following command to install Lazydocker:

    ```bash
    choco install lazydocker
    ```

4. Once the installation is complete, you can start Lazydocker by typing:

   ```bash
   lazydocker
   ```

Reference: <https://github.com/jesseduffield/lazydocker>
