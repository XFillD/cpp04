name = inception

all:
	@printf "Launch configuration ${name}...\n"
	@bash srcs/requirements/wordpress/tools/make_dir.sh
	@docker compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d --build

down:
	@printf "Stopping configuration ${name}...\n"
	@docker compose -f ./srcs/docker-compose.yml --env-file srcs/.env down

re: down all

clean: down
	@printf "Cleaning configuration ${name}...\n"
	@docker system prune -a
	@sudo rm -rf ~/data/wordpress/*
	@sudo rm -rf ~/data/mariadb/*

fclean: clean
	@printf "Total clean of all docker configurations\n"
	@docker stop $$(docker ps -qa) 2>/dev/null || true
	@docker rm $$(docker ps -qa) 2>/dev/null || true
	@docker rmi -f $$(docker images -qa) 2>/dev/null || true
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	@docker network rm $$(docker network ls -q) 2>/dev/null || true

.PHONY: all down re clean fclean
