prepare-certs: ## Prepare certs
	chmod +x ../bin/mkcert \
	[ -f ./bin/mkcert ] || ./bin/mkcert -install && ./bin/mkcert -install $(BASE_HOSTNAME) "*.$(BASE_HOSTNAME)" && \
	sudo chown ${USER}:${USER} docker/nginx/ -R && \
	mkdir -p docker/nginx/ssl/default/ && \
	mv $(BASE_HOSTNAME)+1.pem docker/nginx/ssl/default/fullchain.pem && \
	mv $(BASE_HOSTNAME)+1-key.pem docker/nginx/ssl/default/privkey.pem

prepare-nginx: ## Prepare nginx container
	docker-compose -p ${PROJECT_NAME} -f docker-compose.yml up -d --no-deps --build  nginx

prepare-gateway: ## Prepare api-gateway container
	@docker-compose -p ${PROJECT_NAME} -f docker-compose.yml up -d --no-deps --build api-gateway

prepare-git: ## git checkout master && git pull origin master
	@for s in $(PHP_SERVICES) $(NODE_SERVICES) $(SPECIAL_SERVICES); do \
		cd $(WORKDIR)$$s && git checkout master && git pull origin master; \
	done

prepare-containers:  ## Prepare containers
	for s in $(PHP_SERVICES) $(SHARED_PHP_SERVICES); do \
		echo "Prepare container $$s"; \
		docker-compose -p ${PROJECT_NAME} -f docker-compose.yml up -d --no-deps $$s ; \
		docker-compose -p ${PROJECT_NAME} -f docker-compose.yml exec $$s sh -c 'which composer && ${PREP_COMPOSER} || exit 0'; \
		docker-compose -p ${PROJECT_NAME} -f docker-compose.yml stop $$s; \
	done

prepare-composer: ## composer i running container
	@for s in $(PHP_SERVICES) ;  do \
		echo "Prepare composer for $$s"; \
		docker-compose -p ${PROJECT_NAME} -f docker-compose.yml exec $$s sh -c 'which composer && ${PREP_COMPOSER} || exit 0'; \
	done

prepare-front: ## yarn install for front service
	@for s in $(NODE_SERVICES) ; do \
		echo "Yarn install for $$s"; \
		cd $(WORKDIR)$$s && yarn install; \
	done