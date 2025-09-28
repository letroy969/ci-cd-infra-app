# Setup Guide for CI/CD Infrastructure Project

## Prerequisites

### Local Environment Requirements
- **Git**: For version control
- **Docker**: For building container images
- **Terraform >= 1.3**: For infrastructure provisioning
- **AWS CLI v2**: For AWS operations

### AWS Account Setup
- AWS account with admin/sandbox privileges
- Permissions to create: VPC, ECS, ECR, ALB, IAM resources
- AWS credentials configured locally

### GitHub Repository Setup
1. Create a new empty repository on GitHub named `ci-cd-infra-app`
2. Set up the following GitHub Secrets in your repository settings:

## Required GitHub Secrets

Navigate to your GitHub repository → Settings → Secrets and variables → Actions → New repository secret

Add these secrets:

```
AWS_ACCESS_KEY_ID: your-aws-access-key
AWS_SECRET_ACCESS_KEY: your-aws-secret-access-key
AWS_REGION: us-east-1 (or your preferred region)
AWS_ACCOUNT_ID: your-12-digit-aws-account-id
```

## Local Setup Commands

### 1. Connect to GitHub Repository
```bash
cd ci-cd-infra-app
git remote add origin https://github.com/YOUR_USERNAME/ci-cd-infra-app.git
git branch -M main
git push -u origin main
```

### 2. Test Infrastructure Locally (Optional)
```bash
cd terraform
terraform init
terraform plan -var "aws_region=YOUR_AWS_REGION" -var "app_name=ci-cd-app" -var "desired_count=0"
terraform apply -var "aws_region=YOUR_AWS_REGION" -var "app_name=ci-cd-app" -var "desired_count=0" -auto-approve
```

### 3. Test Flask App Locally (Optional)
```bash
cd app
pip install -r requirements.txt
python app.py
# Visit http://localhost:80
```

### 4. Test Docker Build Locally (Optional)
```bash
cd app
docker build -t test-app .
docker run -p 8080:80 test-app
# Visit http://localhost:8080
```

## How the CI/CD Pipeline Works

### Job 1: Infrastructure (Terraform Apply)
- Provisions AWS infrastructure with `desired_count=0`
- Creates VPC, ALB, ECR, ECS cluster, IAM roles
- ECS service is created but no tasks are running
- Saves Terraform outputs as artifacts

### Job 2: Build and Deploy
- Builds Docker image from the Flask app
- Pushes image to ECR with commit SHA and `:latest` tags
- Updates ECS service to `desired_count=1`
- Forces new deployment to pick up the latest image
- Waits for deployment to stabilize
- Runs smoke test on `/health` endpoint

## Pipeline Triggers
- Runs automatically on every push to `main` branch
- Can be manually triggered from GitHub Actions tab

## Infrastructure Components Created

### Networking
- VPC with public/private subnets across 2 AZs
- NAT Gateway for private subnet internet access
- Security groups for ALB and ECS tasks

### Application Load Balancer
- Internet-facing ALB in public subnets
- Target group with health checks on `/health`
- HTTP listener on port 80

### Container Infrastructure
- ECR repository for storing Docker images
- ECS Fargate cluster
- Task definition with 256 CPU / 512 MB memory
- ECS service with Fargate launch type

### IAM
- ECS task execution role
- Attached AWS managed policy for task execution

## Cleanup Commands

### Destroy Infrastructure
```bash
cd terraform
terraform destroy -var "aws_region=YOUR_AWS_REGION" -var "app_name=ci-cd-app" -auto-approve
```

### Remove ECR Images (if needed)
```bash
aws ecr batch-delete-image --repository-name ci-cd-app --image-ids imageTag=latest
aws ecr batch-delete-image --repository-name ci-cd-app --image-ids imageTag=COMMIT_SHA
```

## Troubleshooting

### Common Issues
1. **AWS credentials not configured**: Run `aws configure`
2. **GitHub secrets not set**: Verify all required secrets are configured
3. **Terraform state conflicts**: Use `terraform refresh` or destroy/recreate
4. **ECS deployment timeout**: Check ECS service events in AWS console
5. **Health check failures**: Verify Flask app is responding on port 80

### Useful Commands
```bash
# Check ECS service status
aws ecs describe-services --cluster ci-cd-app-cluster --services ci-cd-app-service

# View ECS service logs
aws logs describe-log-groups --log-group-name-prefix /ecs/ci-cd-app

# Check ALB target health
aws elbv2 describe-target-health --target-group-arn TARGET_GROUP_ARN
```

## Cost Considerations
- NAT Gateway: ~$45/month
- ALB: ~$16/month + data processing
- ECS Fargate: ~$0.04/hour for 256 CPU / 512 MB
- ECR: Storage costs for images
- VPC endpoints: Free tier available

**Estimated monthly cost**: ~$60-80 for always-on infrastructure
