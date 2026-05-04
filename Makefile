build:
	docker compose build

up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f

test:
	curl http://localhost:8000/health

clean:
	docker system prune -a -f

shell:
	docker exec -it statuspulse-app bash