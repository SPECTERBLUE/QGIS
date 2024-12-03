# Variables
DOCKER_IMAGE=qgis-custom-image
DOCKER_TAG=latest
DOCKERFILE=.docker/qgis.dockerfile
DOCKER_COMPOSE_FILE=docker-compose-testing.yml

# Environment variables
QGIS_WORKSPACE=/path/to/qgis/workspace
QGIS_COMMON_GIT_DIR=/path/to/qgis/common/git/dir

.PHONY: build run up down clean logs shell

# Build the QGIS Docker image with a custom Dockerfile
build:
	@echo "Building QGIS Docker image using $(DOCKERFILE)..."
	docker build -t $(DOCKER_IMAGE):$(DOCKER_TAG) -f $(DOCKERFILE) .

# Run a container from the built image
run:
	@echo "Running QGIS container..."
	@bash -c 'xhost + && \
	docker run --rm -it \
		-v $(QGIS_WORKSPACE):/root/QGIS \
		-v $(QGIS_COMMON_GIT_DIR):$(QGIS_COMMON_GIT_DIR) \
		-e DISPLAY=$(DISPLAY) \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		$(DOCKER_IMAGE):$(DOCKER_TAG) /bin/bash'

# Use Docker Compose to start services
up:
	@echo "Starting services with Docker Compose..."
	docker-compose -f $(DOCKER_COMPOSE_FILE) up -d

# Stop services
down:
	@echo "Stopping services with Docker Compose..."
	docker-compose -f $(DOCKER_COMPOSE_FILE) down

# Remove all stopped containers, unused networks, images, and volumes
clean:
	@echo "Cleaning up Docker environment..."
	docker system prune -f
	docker volume prune -f

# Show logs from running services
logs:
	@echo "Showing logs from services..."
	docker-compose -f $(DOCKER_COMPOSE_FILE) logs -f

# Open a shell in the qgis-deps container
shell:
	@echo "Opening shell in qgis-deps container..."
	docker exec -it qgis-deps /bin/bash
