# Blue and Green Deployment for a Static Website (t2s-services.com) on S3

This guide demonstrates how to implement Blue-Green Deployment for a static website using S3 and CloudFront with different index.html files for Blue and Green environments.

----
## Prerequisites

- AWS Account: Ensure you have access to AWS.

- AWS CLI Installed: Download and configure the AWS CLI (AWS CLI Installation Guide).

- Domain Name: You need a domain (e.g., t2s-services.com) and set it up in Route 53 (optional for custom domain).

- IAM Permissions: Ensure your user has permission to manage S3, CloudFront, and Route 53.

----
## Use Cases

- Zero Downtime Deployments: Deploy updates without affecting live traffic.

- Testing and Validation: Test updates in the Green environment before switching traffic.

- Rollback Capability: Quickly revert to the Blue environment if issues arise.

- High Availability: Ensure website availability during updates.

----
## Step-by-Step Guide

### Step 1: Create S3 Buckets for Blue and Green Environments

Create a Blue Environment Bucket
```bash
aws s3 mb s3://t2s-services-blue --region us-east-1
``` 

Create a Green Environment Bucket
```bash
aws s3 mb s3://t2s-services-green --region us-east-1 
```

Enable static website hosting on both buckets:
```bash
aws s3 website s3://t2s-services-blue/ --index-document index.html
aws s3 website s3://t2s-services-green/ --index-document index.html
```

Ensure the Bucket Policy Allows Public Access
- Create a file, s3-bucket-policy.json, and add the following content: 
```bash
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::t2s-services-blue/*"
    }
  ]
}
```
- Replace <bucket-name> with the desired name.
- Update your Bucket policy with the above policy to allow public read access.
```bash
aws s3api put-bucket-policy --bucket <bucket-name> --policy file://s3-bucket-policy
```

If you get an error message related to "AccessDenied" when calling the PutBucketPolicy operation, run this command first: 
```bash
aws s3api put-public-access-block --bucket t2s-services-blue --public-access-block-configuration '{
    "BlockPublicAcls": false,
    "IgnorePublicAcls": false,
    "BlockPublicPolicy": false,
    "RestrictPublicBuckets": false
}'
```

Do it again, but this time, for "t2s-services-green." 
```bash
aws s3api put-public-access-block --bucket t2s-services-green --public-access-block-configuration '{
    "BlockPublicAcls": false,
    "IgnorePublicAcls": false,
    "BlockPublicPolicy": false,
    "RestrictPublicBuckets": false
}'
```

The command ensures that public policies are allowed on the bucket. 

### Step 2: Create index.html for Blue and Green Environments
Blue Environment (blue/index.html):
```bash
<!DOCTYPE html>
<html>
<head>
    <title>Blue Environment</title>
    <style>
        body {
            background-color: blue;
            color: white;
            text-align: center;
            font-family: Arial, sans-serif;
        }
    </style>
</head>
<body>
    <h1>Welcome to the Blue Environment!</h1>
</body>
</html>
```

Green Environment (green/index.html):
```bash
<!DOCTYPE html>
<html>
<head>
    <title>Green Environment</title>
    <style>
        body {
            background-color: green;
            color: white;
            text-align: center;
            font-family: Arial, sans-serif;
        }
    </style>
</head>
<body>
    <h1>Welcome to the Green Environment!</h1>
</body>
</html>
```

### Step 3: Upload Files to S3
Upload the index.html files to the respective S3 buckets.

- Upload Blue Environment File
```bash
aws s3 cp ./blue/index.html s3://t2s-services-blue/index.html
```
- Upload Green Environment File
```bash
aws s3 cp ./green/index.html s3://t2s-services-green/index.html
```

### Step 4: Configure CloudFront Distribution

**Use CloudFront to manage traffic switching.**
- On the Console. 

### Step 5: Configure Route 53 (Optional)

Point your domain to the CloudFront distribution.

Create a Hosted Zone (if not already created)

Create Alias Record for www.t2s-services.com

### Step 6: Deploy and Switch Between Environments

Use a Bash Shell script to Automate the Switch: 
```bash
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
```

Deploy to Green Environment

Update the CloudFront origin to point to the Green Bucket:
```bash
aws cloudfront update-distribution --id <distribution-id> --distribution-config file://update-green.json
```

**update-green.json:** 
```bash
{
  "Origins": {
    "Items": [
      {
        "Id": "GreenOrigin",
        "DomainName": "t2s-services-green.s3-website-us-east-1.amazonaws.com",
        "OriginPath": "",
        "CustomHeaders": {
          "Quantity": 0
        }
      }
    ]
  }
}
```

**Invalidate Cache**

Force cache refresh to reflect the Green deployment:
```bash
aws cloudfront create-invalidation --distribution-id <distribution-id> --paths "/*"
```

**Rollback to Blue Environment**
You can follow the same steps to point CloudFront back to the Blue Bucket.

### Step 7: Test and Verify
- Open the domain (www.t2s-services.com) and verify the content.
- Confirm Blue or Green environment is active based on the background color.

### Step 8: Clean Up
If you want to clean up resources after the project:
```bash
# Empty S3 Buckets
aws s3 rm s3://t2s-services-blue --recursive
aws s3 rm s3://t2s-services-green --recursive

# Delete S3 Buckets
aws s3 rb s3://t2s-services-blue --force
aws s3 rb s3://t2s-services-green --force

# Delete CloudFront Distribution
aws cloudfront delete-distribution --id <distribution-id>

# Delete Route 53 Hosted Zone
aws route53 delete-hosted-zone --id <hosted-zone-id>
```


