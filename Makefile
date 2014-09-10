TAG=$(shell git rev-parse --abbrev-ref HEAD)
IMAGE=3scale/openresty:$(TAG)
REPOSITORY=quay.io/$(IMAGE)

build:
	docker build -t $(REPOSITORY) .

tag:
	docker tag $(IMAGE) $(REPOSITORY)
