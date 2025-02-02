# X11 Test Project

## Introduction
This project provides a Docker-based environment for testing and running X11 applications. It simplifies setting up and managing X11 clients in isolated containers.

## Prerequisites
- Docker installed on your system.
- docker-compose installed.

## Installation
1. Clone this repository to your local machine.
2. Navigate to the project directory

## Usage

### 1. Building the Containers
Run the following command to build all Docker containers defined in docker-compose.yml:
```bash
docker-compose build
```

### 2. Starting the Containers
Start the X11 server and client containers with:
```bash
docker-compose up -d
```
- `-d` runs the containers in detached mode.

### 3. Accessing the Containers
To access the running containers, use their names or IDs from `docker ps`.

#### X11 Client Container
```bash
docker-compose exec x11 bash
```

### 4. Stopping the Containers
Stop all containers with:
```bash
docker-compose stop
```

### 5. Removing the Containers
Remove all containers and volumes with:
```bash
docker-compose down --volumes
```
