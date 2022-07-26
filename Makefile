SHELL=/bin/bash
UID=$(shell id -u)

include .env

help:  ## Display command list
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

privilege: ## add user to docker group. After run "exec su -l $USER"
	sudo gpasswd -a ${USER} docker

install-certs: ## install-certs
	sudo apt-get install libnss3-tools
	wget https://github.com/rfay/mkcert/releases/download/v1.4.1-alpha1/mkcert-v1.4.1-alpha1-linux-amd64 -O ./bin/mkcert
	chmod +x ./bin/mkcert

prepare-certs: ## prepare-certs
	chmod +x ../bin/mkcert \
	[ -f ./bin/mkcert ] || ./bin/mkcert -install && ./bin/mkcert -install $(BASE_HOSTNAME) "*.$(BASE_HOSTNAME)" && \
	sudo chown ${USER}:${USER} docker/nginx/ -R && \
	mkdir -p docker/nginx/ssl/default/ && \
	mv $(BASE_HOSTNAME)+1.pem docker/nginx/ssl/default/fullchain.pem && \
	mv $(BASE_HOSTNAME)+1-key.pem docker/nginx/ssl/default/privkey.pem

prepare-nginx: ## Prepare nginx container
	docker-compose -p ${PROJECT_NAME} -f docker-compose.yml up -d --no-deps --build  nginx

prepare-gateway: ## prepare api-gateway container
	@docker-compose -p ${PROJECT_NAME} -f docker-compose.yml up -d --no-deps --build api-gateway

run: ## run project
	@docker-compose -p ${PROJECT_NAME} -f docker-compose.yml up -d

stop: ## stop projects
	@docker-compose -p ${PROJECT_NAME} -f docker-compose.yml stop
