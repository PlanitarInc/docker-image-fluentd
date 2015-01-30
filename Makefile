# XXX no versioning of the docker image
IMAGE_NAME=planitar/fluentd

ifneq ($(NOCACHE),)
  NOCACHEFLAG=--no-cache
endif

.PHONY: build push clean test

build:
	docker build ${NOCACHEFLAG} -t ${IMAGE_NAME} .

push:
	docker push ${IMAGE_NAME}

clean:
	docker rmi -f ${IMAGE_NAME} || true

test:
