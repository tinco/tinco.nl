FROM node:18 AS dev
RUN apt-get update && apt-get install -y make && \
    npm install -g coffeescript node-sass concurrently nodemon live-server && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
WORKDIR /app
CMD ["sh", "-c", "make build && concurrently \"nodemon -e coffee,scss --watch tinco.coffee --watch tinco.scss --exec 'make build'\" \"live-server public --wait=200 --port=8080 --no-browser\""]

FROM node:18 AS builder
RUN apt-get update && apt-get install -y make && \
    npm install -g coffeescript node-sass && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY . .
RUN make build

FROM nginx
COPY --from=builder /app/public/ /usr/share/nginx/html/
