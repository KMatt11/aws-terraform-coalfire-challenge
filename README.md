AWS Technical Challenge - Coalfire

Infrastructure Overview:

The Terraform scripts included in this project deploy the following AWS resources:

**VPC and Subnets**

1 VPC (10.1.0.0/16)

4 Subnets (2 public, 2 private)

**Internet Gateway and NAT Gateway**

Route tables for public and private subnets

**Compute Resources**

EC2 instances managed by an Auto Scaling Group in private subnets

Red Hat Linux instances with 20 GB storage (using the apache.sh script to install Apache)

An IAM role that allows the ASG host to read from the "images" s3 bucket

**Load Balancing**

Application Load Balancer listening on TCP port 80 (http)

ALB to forward traffic to the ASG instances on port 443

**Storage s3 Buckets**

1 s3 bucket named "images" with a lifecycle rule to move objects from the "memes" folder to Glacier after 90 days

1 s3 bucket named "logs" with lifecycle policies to archive old data and delete inactive content

**Security**

Security groups to restrict access to resources appropriately 

**Prerequisites**

Terraform v1.5.0 or greater

AWS CLI configured with appropriate credentials.

An AWS account to deploy the infrastructure.

**Usage**

1. Clone this repository to your local machine:

git clone <repository-url>

2. Initialize the Terraform working directory:

terraform init

3. Review and validate the Terraform plan:

terraform plan

4. Apply the Terraform plan to create the infrastructure:

terraform apply

5. Once you're done, clean up the resources to avoid unnecessary costs:

terraform destroy
