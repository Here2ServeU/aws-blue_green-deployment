# T2S Services Blue-Green Deployment with Terraform

This project implements a Blue-Green Deployment architecture using Terraform. It sets up S3 buckets, CloudFront distributions, and Route 53 DNS records for T2S Services in reusable modules. 

The deployment supports multiple environments: dev, stage, and prod.

---

### Modules

**1. S3 Bucket Module**

The s3_bucket module creates S3 buckets for the Blue and Green environments, enabling static website hosting.

Key Resources:
	•	S3 Bucket
	•	S3 Bucket Policy

**2. CloudFront Module**

The cloudfront module sets up a CloudFront distribution, configured to route traffic to the Blue or Green S3 bucket.

Key Features:
	•	Default Cache Behavior
	•	Origin Access Identity (OAI) for private buckets

**3. DNS Module**

The dns module creates a CNAME record in Route 53 to point your custom domain to the CloudFront distribution.

---

### Requirements

- AWS CLI installed and configured.
- Terraform installed (version >= 1.0.0).
- Access to an AWS account with the following services:
	•	S3
	•	CloudFront
	•	Route 53

---

### Setup Instructions

**Step 1: Clone the Repository to Your Local System**

```bash
git clone https://github.com/Here2ServeU/aws-blue_green-deployment/
cd aws-blue_green-deployment/
```

**Step 2: Initialize Terraform**

Navigate to the desired environment directory (***dev***, ***stage***, or ***prod***) and initialize Terraform:
```bash
terraform init
```

**Step 2: Configure Variables**

Set up the terraform.tfvars file in the environment folder. Example for dev:
```bash
environment = "dev"
zone_id     = "Z1EXAMPLEZONEID"
```

**Step 3: Plan the Deployment**

Preview the resources Terraform will create:
```bash
terraform plan -var-file="terraform.tfvars"
```

**Step 4: Apply the Deployment**
Deploy the resources to AWS:
```bash
terraform apply -var-file="terraform.tfvars"
```

**Step 5: Verify the Deployment**

- Verify that the S3 buckets for Blue and Green are created.
- Check that the CloudFront distribution is pointing to the Blue bucket by default.
- Confirm that the DNS record points to the CloudFront domain.

---

### Blue-Green Deployment Workflow

**Switch from Blue to Green**

To switch traffic from the Blue bucket to the Green bucket:

- Update the main.tf file in the environment directory:
```bash
origin_domain_name = module.s3_green.bucket_name
origin_id          = "S3-t2s-services-green"
```

- Reapply the Terraform configuration:
```bash
terraform apply -var-file="terraform.tfvars"
```

**Rollback to Blue**

To rollback traffic to the Blue bucket:

- Update the main.tf file in the environment directory:
```bash
origin_domain_name = module.s3_blue.bucket_name
origin_id          = "S3-t2s-services-blue"
```

- Reapply the Terraform configuration:
```bash
terraform apply -var-file="terraform.tfvars"
```

---

### Outputs

After a successful deployment, Terraform will output:
- Blue Bucket Name: Name of the Blue environment S3 bucket.
- Green Bucket Name: Name of the Green environment S3 bucket.
- CloudFront Domain Name: URL of the CloudFront distribution.
- DNS Record: Fully qualified domain name for the Route 53 CNAME record.

---

### How To Access Your Application

**Access the Blue Environment**

Access the website hosted in the Blue bucket via the CloudFront URL:
```bash
https://<cloudfront-domain-name>
```

---

## Clean Up

To destroy all resources for an environment, **navigate to the environment directory** and run:
```bash
terraform destroy -var-file="terraform.tfvars"
```

---
#### Author
This project was created for T2S Services. Please reach out to the author for further assistance or feature requests.
