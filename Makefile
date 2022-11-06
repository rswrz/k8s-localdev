all: docker-build k-apply

docker-build:
	docker build -t git ./containers/git

k-apply:
	kubectl apply -k ./kustomize

clean:
	kubectl delete -k ./kustomize

purge: clean
	docker image rm git
