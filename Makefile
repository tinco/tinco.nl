all: dev

build:
	node-sass -o public *.scss 
	coffee -o public -c *.coffee 

docker:
	docker build --platform=linux/amd64 -t tinco/tinco.nl .
	docker push tinco/tinco.nl

dev:
	docker build --target dev -t tinco.nl-dev .
	docker run --rm -it -p 8080:8080 -v `pwd`:/app tinco.nl-dev
        
.PHONY: all test clean docker dev
