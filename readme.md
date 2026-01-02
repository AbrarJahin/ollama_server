# Ollama (Docker) – Local Model Store in Project Folder

This setup runs **Ollama** in Docker and stores **downloaded models inside the repo folder** (e.g., on your larger `D:` drive), not on Docker's default volume storage.

## What gets stored where

- **Code / Compose / Makefile**: this repo folder
- **Downloaded models & Ollama data**: `./ollama_data/` (created next to `docker-compose.ollama.yml`)
- **Docker image layers**: Docker’s internal image cache (still managed by Docker)

> Tip (Windows): clone/move this repo onto your large drive (example: `D:\Code\ollama_server`) so `ollama_data` also lives there.

## Quick start

```bash
make ollama-up
make ollama-pull
make ollama-test
```

## Makefile commands

| Command                 | What it does                                                                                      |
| ----------------------- | ------------------------------------------------------------------------------------------------- |
| `make ollama-up`        | Starts the Ollama container in the background (`docker compose up -d`).                           |
| `make ollama-down`      | Stops the container but **keeps** downloaded models in `./ollama_data`.                           |
| `make ollama-destroy`   | Stops the container and **deletes** stored models/data (removes volumes/bind data use carefully). |
| `make ollama-logs`      | Follows the Ollama container logs.                                                                |
| `make ollama-ps`        | Shows container status for this compose file.                                                     |
| `make ollama-pull`      | Pulls the pinned LLM model + embedding model into the local Ollama store.                         |
| `make ollama-pull-fast` | Pulls an optional smaller/faster LLM model.                                                       |
| `make ollama-list`      | Lists all models currently available in the local Ollama store.                                   |
| `make ollama-version`   | Prints the Ollama version running in the container.                                               |
| `make ollama-test`      | Calls the local Ollama API tags endpoint as a quick health check.                                 |

## Notes

- If you run into permission issues creating `ollama_data/`, create it manually once:
  - Windows: create a folder named `ollama_data` in the repo root
  - Linux/macOS: `mkdir -p ollama_data`
