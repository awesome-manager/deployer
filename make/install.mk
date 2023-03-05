download: ## Download git repositories
	for s in $(PHP_SERVICES) ; do \
		[ -d "$(WORKDIR)/$$s" ] || git clone $(GIT_HOST)/$(GIT_REP)/$$s.git $(WORKDIR)/$$s; \
		if ! [ -f "$(WORKDIR)/$$s/.env" ] && [ -f "env/$$s.env" ]; then echo "Copying env file to $$s" && cat env/$$s.env |sed -e "s/main_cache/${CACHE_PREFIX}/g"| sed  -e "s/db_host_ip/${DB_HOST}/g"| sed  -e "s/db_username/${POSTGRES_USER}/g"| sed  -e "s/db_password/${POSTGRES_PASSWORD}/g" > $(WORKDIR)/$$s/.env; fi \
	done
	for s in $(NODE_SERVICES) $(SPECIAL_SERVICES); do \
		[ -d "$(WORKDIR)/$$s" ] || git clone $(GIT_HOST)/$(GIT_REP)/$$s.git $(WORKDIR)/$$s; \
	done

install-certs: ## Install certs
	sudo apt-get install libnss3-tools
	wget https://github.com/rfay/mkcert/releases/download/v1.4.1-alpha1/mkcert-v1.4.1-alpha1-linux-amd64 -O ./bin/mkcert
	chmod +x ./bin/mkcert

uid: ## change www-data uid in all containers to current user
	@for s in $(PHP_SERVICES) ; do \
		docker-compose -p ${PROJECT_NAME} -f docker-compose.yml up -d --no-deps $$s; \
		docker-compose -p ${PROJECT_NAME} -f docker-compose.yml exec $$s bash -c 'if [[ ${UID} -ne 0 ]]; then usermod -u ${UID} www-data; fi'; \
		docker-compose -p ${PROJECT_NAME} -f docker-compose.yml stop $$s; \
	done