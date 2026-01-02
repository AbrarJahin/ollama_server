# ---- Pinned versions (no surprises) ----
OLLAMA_IMAGE ?= ollama/ollama:0.13.5
OLLAMA_COMPOSE ?= docker-compose.ollama.yml
OLLAMA_CONTAINER ?= ollama

# ---- Pinned models (edit here intentionally only) ----
LLM_MODEL ?= qwen2.5:14b-instruct
EMBED_MODEL ?= bge-m3
# Optional fast fallback
LLM_MODEL_FAST ?= qwen2.5:7b-instruct

.PHONY: ollama-up ollama-down ollama-destroy ollama-logs ollama-ps \
        ollama-pull ollama-pull-fast ollama-list ollama-test ollama-version

# Start Ollama in Docker (runs in background)
ollama-up:
	docker compose -f $(OLLAMA_COMPOSE) up -d

# Stop containers (keeps downloaded models on disk)
ollama-down:
	docker compose -f $(OLLAMA_COMPOSE) down

# Stop + remove containers, networks, and volumes (DELETES downloaded models)
ollama-destroy:
	docker compose -f $(OLLAMA_COMPOSE) down -v --remove-orphans

# Follow container logs
ollama-logs:
	docker logs -f $(OLLAMA_CONTAINER)

# Show containers
ollama-ps:
	docker compose -f $(OLLAMA_COMPOSE) ps

# Pull the pinned models into the local Ollama store
ollama-pull:
	docker exec -it $(OLLAMA_CONTAINER) ollama pull $(LLM_MODEL)
	docker exec -it $(OLLAMA_CONTAINER) ollama pull $(EMBED_MODEL)
	@echo ""
	@echo "Optional fast model:"
	@echo "  make ollama-pull-fast"

ollama-pull-fast:
	docker exec -it $(OLLAMA_CONTAINER) ollama pull $(LLM_MODEL_FAST)

# List locally available models
ollama-list:
	docker exec -it $(OLLAMA_CONTAINER) ollama list

# Print Ollama version
ollama-version:
	docker exec -it $(OLLAMA_CONTAINER) ollama --version

# Quick API smoke test (prints first ~400 chars)
ollama-test:
	curl -s http://127.0.0.1:11434/api/tags | head -c 400 && echo
