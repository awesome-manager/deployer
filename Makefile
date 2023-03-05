SHELL=/bin/bash
UID=$(shell id -u)
PHP_SERVICES = idm-data project-data site-data team-data
NODE_SERVICES = manager-front
SPECIAL_SERVICES = api-gateway
PREP_COMPOSER = cd /var/www/ && composer install && chown ${UID}:${UID} vendor/ -R
GIT_HOST=https://github.com
GIT_REP=awesome-manager

include .env
include ./make/install.mk
include ./make/prepare.mk

help:  ## Display command list
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

all: privilege install-certs download uid prepare-certs prepare-nginx prepare-containers prepare-front ## Make all work

privilege: ## add user to docker group. After run "exec su -l $USER"
	sudo gpasswd -a ${USER} docker

run: ## run project
	@docker-compose -p ${PROJECT_NAME} -f docker-compose.yml up -d

stop: ## stop projects
	@docker-compose -p ${PROJECT_NAME} -f docker-compose.yml stop
