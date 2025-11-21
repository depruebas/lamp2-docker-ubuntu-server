#!/bin/bash

.PHONY: all create_network apache2 mysql postgresql

# Defines the base path of the current directory
BASE_DIR := $(CURDIR)

# Name of the network used in the project
NETWORK_NAME := lamp-network

# IP address range used in the project
SUBNET := 172.45.0.0/24

all: create_network apache2 mysql postgresql

create_network:
	@if ! docker network inspect $(NETWORK_NAME) >/dev/null 2>&1; then \
		echo "Creating network $(NETWORK_NAME) with subnet $(SUBNET)..."; \
		docker network create --subnet=$(SUBNET) $(NETWORK_NAME); \
	else \
		echo "Network $(NETWORK_NAME) already exists."; \
	fi

apache2:
	@echo "Starting Ubuntu Server Apache2 container..."
	cd $(BASE_DIR)/apache2/docker && docker-compose -p lamp_apache2 up -d

mysql:
	@echo "Starting Ubuntu Server MySql container..."
	cd $(BASE_DIR)/mysql/docker && docker-compose -p lamp_mysql up -d

postgresql:
	@echo "Starting Ubuntu Server PostgreSQL container..."
	cd $(BASE_DIR)/postgresql/docker && docker-compose -p lamp_pg up -d

down:
	@echo "Destroy containers ..."
	cd $(BASE_DIR)/apache2/docker && docker-compose -p lamp_apache2 down -v
	cd $(BASE_DIR)/mysql/docker && docker-compose -p lamp_mysql down -v
	cd $(BASE_DIR)/postgresql/docker && docker-compose -p lamp_pg down -v

build:
	@echo 'Restarting containers ...'
	cd $(BASE_DIR)/apache2/docker && docker-compose -p lamp_apache2 build
	cd $(BASE_DIR)/mysql/docker && docker-compose -p lamp_mysql build
	cd $(BASE_DIR)/postgresql/docker && docker-compose -p lamp_pg build

stop:
	@echo "Stop containers ..."
	cd $(BASE_DIR)/apache2/docker && docker-compose -p lamp_apache2 stop
	cd $(BASE_DIR)/mysql/docker && docker-compose -p lamp_mysql stop
	cd $(BASE_DIR)/postgresql/docker && docker-compose -p lamp_pg stop
	

web:  # Why --user 1000? because 1000 is the ubuntu user 1000 
	@echo "Enter into Ubuntu Server Apache2 container..."
	docker exec -it --user 1000 lamp_apache2 bash

my:  # Why --user 1000? because 1000 is the ubuntu user 1000 
	@echo "Enter into Ubuntu Server MySql container..."
	docker exec -it --user 1000 lamp_mysql bash

pg:  # Why --user 1000? because 1000 is the ubuntu user 1000 
	@echo "Enter into Ubuntu Server PostgreSQL container..."
	docker exec -it --user 1000 lamp_pg bash

help:
	@echo "Available commands:"
	@echo "  make all      			- Create network and start Apache2, MySql & PostgreSQL containers"
	@echo "  make create_network 	- Create the Docker network if it doesn't already exist"
	@echo "  make apache2  			- Start Apache2 PHP container"
	@echo "  make mysql    			- Start MySql container"
	@echo "  make postgresql		- Start PostgreSQL container"
	@echo "  make stop 				- Stop all container"
	@echo "  make Down 				- Stop and remove all container"
	@echo "  make my			 	- Enter into MySql Ubuntu Shell"
	@echo "  make pg 				- Enter into postgreSQL Ubuntu Shell"
	@echo "  make help     - Show this help message"