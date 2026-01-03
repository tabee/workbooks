.PHONY: build run serve stop test clean help

# Default Docker image name
IMAGE_NAME := mkdocs-env

help: ## Show this help message
	@echo "MkDocs Docker Environment - Available commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""

build: ## Build the Docker image
	docker build -t $(IMAGE_NAME) .

run: ## Run MkDocs server (alias for serve)
	@$(MAKE) serve

serve: ## Serve documentation on http://localhost:8000
	docker run -it --rm -p 8000:8000 -v $$(pwd):/docs $(IMAGE_NAME)

build-docs: ## Build static documentation site
	docker run --rm -v $$(pwd):/docs $(IMAGE_NAME) mkdocs build

new: ## Create a new MkDocs project (usage: make new PROJECT=my-project)
	@if [ -z "$(PROJECT)" ]; then \
		echo "Error: PROJECT name is required. Usage: make new PROJECT=my-project"; \
		exit 1; \
	fi
	docker run --rm -v $$(pwd):/docs $(IMAGE_NAME) mkdocs new $(PROJECT)

shell: ## Open a shell in the container
	docker run -it --rm -v $$(pwd):/docs $(IMAGE_NAME) /bin/bash

test: ## Run tests to verify the Docker setup
	./test-docker.sh

clean: ## Remove built site directory
	rm -rf site/

docker-clean: ## Remove Docker image
	docker rmi $(IMAGE_NAME)

compose-up: ## Start services using docker-compose
	docker-compose up

compose-down: ## Stop services using docker-compose
	docker-compose down

compose-build: ## Build services using docker-compose
	docker-compose build
