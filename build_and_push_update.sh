#!/bin/bash

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check if jq is installed
if ! command_exists jq; then
  echo "Error: 'jq' is not installed. Please install it to continue."
  exit 1
fi

# Check if terraform.tfstate exists
if [ ! -f terraform.tfstate ]; then
  echo "Error: 'terraform.tfstate' file not found. Make sure it exists."
  exit 1
fi

# Extract ECR Repository URL and EMR Release Label
REPO_URL=$(jq -r '.resources[] | select(.type == "aws_ecr_repository").instances[].attributes.repository_url' terraform.tfstate)
EMR_RELEASE_LABEL="emr-6.12.0"

# Check if REPO_URL is empty
if [ -z "$REPO_URL" ]; then
  echo "Error: ECR Repository URL not found in terraform.tfstate."
  exit 1
fi

# Call the build_and_push_image script
./build_and_push_image.sh "$REPO_URL" "$EMR_RELEASE_LABEL"


