all: build

build:
	node-sass -o public *.scss 
	coffee -o public -c *.coffee 

docker:
	docker pull tinco/tinco.nl-buildenv:latest
	docker run -v `pwd`:/app tinco/tinco.nl-buildenv
	docker build -t tinco/tinco.nl .
	docker push tinco/tinco.nl

docker-build-env:
	docker build -t tinco/tinco.nl-buildenv docker/build-env
	docker push tinco/tinco.nl-buildenv
        
.PHONY: all test clean docker
