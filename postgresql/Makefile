#!/bin/bash

.PHONY: all create_network ubuntuserver

# Defines the base path of the current directory
BASE_DIR := $(CURDIR)

# Name of the network used in the project
NETWORK_NAME := lamp-network

# IP address range used in the project
SUBNET := 172.45.0.0/24

all: create_network ubuntuserver

create_network:
	@if ! docker network inspect $(NETWORK_NAME) >/dev/null 2>&1; then \
		echo "Creating network $(NETWORK_NAME) with subnet $(SUBNET)..."; \
		docker network create --subnet=$(SUBNET) $(NETWORK_NAME); \
	else \
		echo "Network $(NETWORK_NAME) already exists."; \
	fi

ubuntuserver:
	@echo "Starting Ubuntu Server container..."
	cd $(BASE_DIR)/docker && docker-compose up -d

down:
	@echo "Destroy containers ..."
	cd $(BASE_DIR)/docker && docker-compose down -v

build:
	@echo 'Restarting containers ...'
	cd $(BASE_DIR)/docker && docker-compose build

stop:
	@echo "Stop containers ..."
	cd $(BASE_DIR)/docker && docker-compose stop

shell:  # Why --user 1000? because 1000 is the ubuntu user 1000 
	@echo "Enter into Ubuntu Server container..."
	docker exec -it --user 1000 adma_pg bash
