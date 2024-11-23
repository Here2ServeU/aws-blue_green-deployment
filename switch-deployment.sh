#!/bin/bash

# Variables
DISTRIBUTION_ID="E1JISPJVH0Z8TO" # Replace with your CloudFront Distribution ID
BLUE_ORIGIN="t2s-services-blue.s3-website-us-east-1.amazonaws.com"
GREEN_ORIGIN="t2s-services-green.s3-website-us-east-1.amazonaws.com"

# Function to get the current ETag
get_etag() {
    aws cloudfront get-distribution-config --id $DISTRIBUTION_ID --query "ETag" --output text
}

# Function to switch the origin
switch_environment() {
    local target_origin=$1
    local etag=$(get_etag)

    echo "Switching to environment: $target_origin"

    # Fetch current distribution config
    aws cloudfront get-distribution-config --id $DISTRIBUTION_ID > config.json

    # Modify the origin in the config.json file
    jq --arg origin "$target_origin" '.DistributionConfig.Origins.Items[0].DomainName = $origin' config.json > updated-config.json

    # Update the CloudFront distribution
    aws cloudfront update-distribution --id $DISTRIBUTION_ID \
        --distribution-config file://updated-config.json \
        --if-match $etag

    # Clean up temporary file
    rm -f config.json updated-config.json

    # Invalidate the cache to reflect changes immediately
    aws cloudfront create-invalidation --distribution-id $DISTRIBUTION_ID --paths "/*"

    echo "Switched to environment: $target_origin"
}

# Main script
if [ "$1" == "blue" ]; then
    switch_environment $BLUE_ORIGIN
elif [ "$1" == "green" ]; then
    switch_environment $GREEN_ORIGIN
else
    echo "Usage: $0 {blue|green}"
    exit 1
fi
