IMAGE_NAME=dsm
.PHONY: build 
build: 
	# CGO_ENABLED=0 GOOS=${Platform} go build -a -tags netgo -ldflags '-w' .
	# CGO_ENABLED=0 GOOS=linux go build -a -tags netgo -ldflags '-w' .
	CGO_ENABLED=0 GOOS=linux go build  -o dsm-api api/v1/api.go
	
.PHONY: build-container
build-container: build
	sudo docker build \
        -f Dockerfile \
        -t ${IMAGE_NAME}:latest .; \