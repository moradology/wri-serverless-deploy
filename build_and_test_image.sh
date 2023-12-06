#!/bin/bash

echo "Building Docker image..."
docker build -t "wri-gdal-serverless:latest" ./docker
if [ $? -ne 0 ]; then
    echo "Docker build failed"
    exit 1
fi

echo "Validating Docker image..."
if ! command -v amazon-emr-serverless-image &> /dev/null; then
  echo "Error: 'amazon-emr-serverless-image' command not found"
  exit 1
fi
amazon-emr-serverless-image \
    validate-image -r "emr-6.12.0" -t spark \
    -i "wri-gdal-serverless:latest"
if [ $? -ne 0 ]; then
    echo "Image validation failed"
    exit 1
fi

docker run -it --entrypoint="/bin/bash" wri-gdal-serverless:latest

echo "Build and test completed successfully"