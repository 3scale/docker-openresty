TAG=trusty
IMAGE=3scale/openresty:$(TAG)
REPOSITORY=quay.io/$(IMAGE)

build:
	docker build -t $(IMAGE) .

tag:
	docker tag $(IMAGE) $(REPOSITORY)
