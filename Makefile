.DEFAULT_GOAL := help

.PHONY: help
help:  ## Shows this help message
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target> <arg=value>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m  %s\033[0m\n\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ 🚀  Getting started
.PHONY: run
build:  ## build docker
	@docker build . -t test-toolkit --no-cache

up:
	@docker run -p 8000:8000 test-toolkit 

dev:  ## start app in docker, with mounted volume and live reload
	@docker run -p 8000:8000 -v .:/code/ -v /code/.venv test-toolkit uvicorn main:app --reload

##@ 🛠  Tools


format:  ## use ruff to fix all linting problems
	@uv run ruff format .
	@uv run ruff check --fix

typecheck: ## use mypy to check the types
	@uv run mypy .
