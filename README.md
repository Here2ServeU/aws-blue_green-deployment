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
# Enable Static Website Hosting
aws s3 website s3://t2s-services-blue/ --index-document index.html
aws s3 website s3://t2s-services-green/ --index-document index.html
```

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
```bash
# Upload Blue Environment File
aws s3 cp ./blue/index.html s3://t2s-services-blue/index.html

# Upload Green Environment File
aws s3 cp ./green/index.html s3://t2s-services-green/index.html
```

### Step 4: Configure CloudFront Distribution

**Use CloudFront to manage traffic switching.**

- Create a CloudFront Distribution with the Blue Bucket as the initial origin.
- Use the AWS CLI or Console:
	•	Set the Origin Domain Name to t2s-services-blue.s3-website-us-east-1.amazonaws.com.
	•	Note the CloudFront Distribution Domain Name (e.g., d12345.cloudfront.net).

### Step 5: Configure Route 53 (Optional)

Point your domain to the CloudFront distribution.

```bash
# Create a Hosted Zone (if not already created)
aws route53 create-hosted-zone --name "t2s-services.com" --caller-reference "t2s-route53"

# Create Alias Record for www.t2s-services.com
aws route53 change-resource-record-sets --hosted-zone-id <hosted-zone-id> --change-batch file://record.json
```

**record.json:** 
```bash
{
  "Changes": [
    {
      "Action": "CREATE",
      "ResourceRecordSet": {
        "Name": "www.t2s-services.com",
        "Type": "A",
        "AliasTarget": {
          "HostedZoneId": "Z2FDTNDATAQYW2",
          "DNSName": "d12345.cloudfront.net",
          "EvaluateTargetHealth": false
        }
      }
    }
  ]
}
```

### Step 6: Deploy and Switch Between Environments
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
Follow the same steps to point CloudFront back to the Blue Bucket.

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


