USER_NAME = $(USER)
GROUP_NAME = Domain
HOST_PATH = '/home/$(USER_NAME)'
CONTAINER_PATH = '/home/$(USER_NAME)'
ROOT_PASSWORD = 'password'
IMAGE_TAG = 'ymasuyama/pytorch-ltfat'
EXPOSED_PORT = 8888

all: ## build & run docker.
	@make build
	@make run

build: ## build docker.
	docker build -t $(IMAGE_TAG) ./

run: ## run docker.
	docker run -it --gpus all \
	-e USER_NAME=$(USER_NAME) -e GROUP_NAME=$(GROUP_NAME) \
	-e LOCAL_UID=$(shell id -u $(USER)) -e LOCAL_GID=$(shell id -g $(USER)) \
	-p $(EXPOSED_PORT):$(EXPOSED_PORT) \
	-v $(HOST_PATH):$(CONTAINER_PATH) \
	-w $(CONTAINER_PATH) \
	$(IMAGE_TAG) /bin/bash

connect: ## connect newest container
	docker exec -i -t $(CONTAINER_ID) /bin/bash


export NONE_DOCKER_IMAGES=`docker images -f dangling=true -q`
export STOPPED_DOCKER_CONTAINERS=`docker ps -a -q`

clean-all: ## clean images & containers
	-@make clean-images
	-@make clean-containers

clean-images:  ## clean images whose tag is none 
	docker rmi $(NONE_DOCKER_IMAGES) -f

clean-containers:  ## clean stopped containers
	docker rm -f $(STOPPED_DOCKER_CONTAINERS) \

help: ## this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
