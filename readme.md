```
docker compose -f docker-compose.ollama.yml up -d
docker exec -it ollama ollama --version
curl http://127.0.0.1:11434/api/tags
```