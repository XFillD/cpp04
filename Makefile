# **************************************************************************** #
#                                                                              #
#    Inception - Docker Infrastructure                                         #
#                                                                              #
# **************************************************************************** #

NAME		= inception
COMPOSE_FILE	= srcs/docker-compose.yml
DATA_DIR	= /home/$(USER)/data

# Colors
GREEN		= \033[0;32m
YELLOW		= \033[0;33m
RED		= \033[0;31m
NC		= \033[0m

all: setup build up

setup:
	@echo "$(YELLOW)Creating data directories...$(NC)"
	@mkdir -p $(DATA_DIR)/wordpress
	@mkdir -p $(DATA_DIR)/mariadb
	@echo "$(GREEN)Data directories created at $(DATA_DIR)$(NC)"

build:
	@echo "$(YELLOW)Building Docker images...$(NC)"
	@docker compose -f $(COMPOSE_FILE) build
	@echo "$(GREEN)Build complete!$(NC)"

up:
	@echo "$(YELLOW)Starting containers...$(NC)"
	@docker compose -f $(COMPOSE_FILE) up -d
	@echo "$(GREEN)Containers started!$(NC)"

down:
	@echo "$(YELLOW)Stopping containers...$(NC)"
	@docker compose -f $(COMPOSE_FILE) down
	@echo "$(GREEN)Containers stopped!$(NC)"

start:
	@docker compose -f $(COMPOSE_FILE) start

stop:
	@docker compose -f $(COMPOSE_FILE) stop

restart: down up

logs:
	@docker compose -f $(COMPOSE_FILE) logs -f

ps:
	@docker compose -f $(COMPOSE_FILE) ps

clean: down
	@echo "$(YELLOW)Removing containers and networks...$(NC)"
	@docker compose -f $(COMPOSE_FILE) down -v --remove-orphans
	@echo "$(GREEN)Cleanup complete!$(NC)"

fclean: clean
	@echo "$(RED)Removing all Docker data...$(NC)"
	@docker system prune -af
	@sudo rm -rf $(DATA_DIR)
	@echo "$(GREEN)Full cleanup complete!$(NC)"

re: fclean all

status:
	@echo "$(YELLOW)=== Docker Status ===$(NC)"
	@docker compose -f $(COMPOSE_FILE) ps
	@echo ""
	@echo "$(YELLOW)=== Docker Images ===$(NC)"
	@docker images | grep -E "nginx|wordpress|mariadb" || true
	@echo ""
	@echo "$(YELLOW)=== Docker Volumes ===$(NC)"
	@docker volume ls | grep -E "wordpress|mariadb" || true

.PHONY: all setup build up down start stop restart logs ps clean fclean re status
