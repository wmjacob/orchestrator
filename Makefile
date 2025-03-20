init:
	@echo "Initializing project..."
	@find . -name '*.example' -exec sh -c 'target="$${1%.example}"; [ ! -e "$$target" ] && cp "$$1" "$$target"' _ {} \;

init-cluster-prod:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.2/deploy/static/provider/cloud/deploy.yaml
	kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.16.0/cert-manager.yaml
	kubectl create namespace home
	kubectl -n home create secret docker-registry oracle-docker-registry \
		--docker-server=$(DOCKER_SERVER) \
		--docker-username=$(DOCKER_USERNAME) \
		--docker-password='$(DOCKER_PASSWORD)' \
		--docker-email=$(DOCKER_EMAIL)
	kubectl create namespace controllers-system
	kubectl -n controllers-system  create secret docker-registry oracle-docker-registry \
		--docker-server=$(DOCKER_SERVER) \
		--docker-username=$(DOCKER_USERNAME) \
		--docker-password='$(DOCKER_PASSWORD)' \
		--docker-email=$(DOCKER_EMAIL)
	kubectl apply -k ./deployments/production

init-cluster-dev:
	kubectl create namespace home
	kubectl apply -k ./deployments/development
 