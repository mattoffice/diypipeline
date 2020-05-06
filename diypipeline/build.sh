#!/bin/bash

# Timestamp Function
timestamp() {
	date +"%T"
}

# Temporary file for stderr redirects
tmpfile=$(mktemp)

# Go build
build () {
	echo "	$(timestamp): started build script..."
	echo "	$(timestamp): building cicdexample"
	go build 2>tmpfile
	if [ -s tmpfile ]; then
		cat tmpfile
		echo "	$(timestamp): compilation error, exiting"
		exit 1
	fi
}

# Build a docker image
buildDocker() {
	echo "	$(timestamp): building image example:test"
	docker build -t example:test .
}

# Deploy to Minikube using kubectl
deploy() {
	echo " $(timestamp): deploying to Minikube"
	kubectl delete deployment example
	kubectl delete service example
	kubectl apply -f deploy.yml
}

# Orchestrate
echo " Welcome to the Builder builder v0.2, written by github.com/cishiv"
if [[ $1 = "build" ]]; then
	if [[ $2 = "docker" ]]; then
		if [[ $3 = "deploy" ]]; then
			build
			buildDocker
			deploy
		else
			build
			buildDocker
		fi
		echo "✔️	$(timestamp): complete."
		echo "	$(timestamp): exiting..."
	elif [[ $2 = "bin" ]]; then
		build
		echo "✔️	$(timestamp): complete."
		echo "	$(timestamp): exiting..."
	else
		echo "  $(timestamp): missing build argument"
	fi
else
	if [[ $1 = "--help" ]]; then
		echo "build - start a build to produce artifacts"
		echo "	docker - produces docker images"
		echo " 	bin - produces executable binaries"
	else
		echo "$(timestamp): no arguments passed, type --help for a list of arguments"
	fi
fi
rm -f tmpfile