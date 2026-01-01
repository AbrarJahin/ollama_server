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
        ollama-pull ollama-list ollama-test ollama-version

ollama-up:
	docker compose -f $(OLLAMA_COMPOSE) up -d

ollama-down:
	docker compose -f $(OLLAMA_COMPOSE) down

# Destroys everything INCLUDING the model volume (clean slate)
ollama-destroy:
	docker compose -f $(OLLAMA_COMPOSE) down -v

ollama-logs:
	docker logs -f $(OLLAMA_CONTAINER)

ollama-ps:
	docker ps --filter "name=$(OLLAMA_CONTAINER)"

# Pull pinned models ONCE (explicit). No auto-updates.
ollama-pull:
	docker exec -it $(OLLAMA_CONTAINER) ollama pull $(LLM_MODEL)
	docker exec -it $(OLLAMA_CONTAINER) ollama pull $(EMBED_MODEL)
	@echo "Optional fast model:"
	@echo "  make ollama-pull-fast"

ollama-pull-fast:
	docker exec -it $(OLLAMA_CONTAINER) ollama pull $(LLM_MODEL_FAST)

ollama-list:
	docker exec -it $(OLLAMA_CONTAINER) ollama list

ollama-version:
	docker exec -it $(OLLAMA_CONTAINER) ollama --version

ollama-test:
	curl -s http://127.0.0.1:11434/api/tags | head -c 400 && echo
