TAG=$(shell git rev-parse --abbrev-ref HEAD)
IMAGE=3scale/openresty:$(TAG)
REPOSITORY=quay.io/$(IMAGE)

build:
	docker build -t $(REPOSITORY) .

test:
	docker run $(REPOSITORY) openresty -V


bash:
	docker run -t -i $(REPOSITORY) bash
