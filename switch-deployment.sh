#!/bin/bash

# Variables
DISTRIBUTION_ID="E1JISPJVH0Z8TO" # Replace with your CloudFront distribution ID
BLUE_BUCKET="t2s-services-blue.s3.amazonaws.com"
GREEN_BUCKET="t2s-services-green.s3.amazonaws.com"

# Function to get the current ETag
get_etag() {
    aws cloudfront get-distribution-config --id $DISTRIBUTION_ID --query "ETag" --output text
}

# Function to switch to a specific environment
switch_environment() {
    local target_bucket=$1
    local etag=$(get_etag)

    echo "Switching to environment: $target_bucket"

    # Get the current distribution config
    aws cloudfront get-distribution-config --id $DISTRIBUTION_ID > config.json

    # Update the origin in the config.json file
    jq --arg bucket "$target_bucket" '.DistributionConfig.Origins.Items[0].DomainName = $bucket' config.json > updated-config.json

    # Update the CloudFront distribution
    aws cloudfront update-distribution --id $DISTRIBUTION_ID \
        --distribution-config file://updated-config.json \
        --if-match $etag

    # Invalidate the cache to reflect changes
    aws cloudfront create-invalidation --distribution-id $DISTRIBUTION_ID --paths "/*"

    echo "Switched to environment: $target_bucket"
}

# Main Script
if [ "$1" == "blue" ]; then
    switch_environment $BLUE_BUCKET
elif [ "$1" == "green" ]; then
    switch_environment $GREEN_BUCKET
else
    echo "Usage: $0 {blue|green}"
    exit 1
fi
