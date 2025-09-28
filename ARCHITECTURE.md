# Architecture Overview

## Project Structure
```
ci-cd-infra-app/
├── .github/workflows/
│   └── deploy.yml              # GitHub Actions CI/CD pipeline
├── app/
│   ├── app.py                  # Flask application
│   ├── requirements.txt        # Python dependencies
│   ├── Dockerfile             # Container definition
│   └── .dockerignore          # Docker ignore patterns
├── terraform/
│   ├── main.tf                # Main Terraform configuration
│   ├── variables.tf           # Input variables
│   └── outputs.tf             # Output values
├── .gitignore                 # Git ignore patterns
├── README.md                  # Project overview
├── SETUP.md                   # Setup instructions
└── ARCHITECTURE.md            # This file
```

## Infrastructure Components

### Networking Layer
- **VPC**: Custom Virtual Private Cloud with CIDR 10.0.0.0/16
- **Public Subnets**: 10.0.1.0/24, 10.0.2.0/24 (across 2 AZs)
- **Private Subnets**: 10.0.3.0/24, 10.0.4.0/24 (across 2 AZs)
- **NAT Gateway**: Single NAT gateway for private subnet internet access
- **Security Groups**: 
  - ALB: Allows HTTP (80) from anywhere
  - ECS: Allows HTTP (80) from ALB only

### Load Balancing Layer
- **Application Load Balancer**: Internet-facing ALB in public subnets
- **Target Group**: HTTP target group with health checks on `/health`
- **Listener**: HTTP listener on port 80 forwarding to target group

### Container Infrastructure
- **ECR Repository**: Private container registry for Docker images
- **ECS Cluster**: Fargate cluster for running containers
- **Task Definition**: 
  - CPU: 256 units
  - Memory: 512 MB
  - Network mode: awsvpc
  - Port mapping: 80:80
- **ECS Service**: 
  - Initially created with desired_count=0
  - Updated to desired_count=1 during deployment
  - Uses private subnets with no public IP

### Security & Access Control
- **IAM Role**: ECS task execution role with necessary permissions
- **Security Groups**: Restrictive network access controls
- **Private Subnets**: ECS tasks run in private subnets for security

## CI/CD Pipeline Flow

### Phase 1: Infrastructure Provisioning
1. **Trigger**: Push to main branch
2. **Job**: Infrastructure (Terraform Apply)
3. **Actions**:
   - Configure AWS credentials
   - Initialize Terraform
   - Apply infrastructure with `desired_count=0`
   - Save Terraform outputs as artifacts

### Phase 2: Application Deployment
1. **Job**: Build and Deploy
2. **Actions**:
   - Download Terraform outputs
   - Configure AWS credentials
   - Login to ECR
   - Build Docker image from Flask app
   - Push image with commit SHA and `:latest` tags
   - Update ECS service to `desired_count=1`
   - Force new deployment
   - Wait for deployment stability
   - Run smoke test on `/health` endpoint

## Application Architecture

### Flask Application
- **Framework**: Flask with Gunicorn WSGI server
- **Endpoints**:
  - `/`: Returns greeting message
  - `/health`: Health check endpoint for load balancer
- **Port**: 80 (mapped to container port 80)
- **Environment**: Runs in container with minimal Python 3.10 slim image

### Container Strategy
- **Base Image**: python:3.10-slim
- **Production Server**: Gunicorn with bind to 0.0.0.0:80
- **Dependencies**: Flask, Gunicorn
- **Build Context**: Optimized with .dockerignore

## Deployment Strategy

### Two-Phase Deployment
1. **Infrastructure Phase**: Create all AWS resources but keep ECS service at 0 tasks
2. **Application Phase**: Build, push, and deploy the application

### Benefits
- **Separation of Concerns**: Infrastructure and application deployment are separate
- **Faster Iterations**: Subsequent deployments only rebuild/push application
- **Rollback Capability**: Can easily scale down to 0 or rollback to previous image
- **Cost Efficiency**: Infrastructure can be created without running tasks initially

## Monitoring & Observability

### Health Checks
- **ALB Health Check**: HTTP GET to `/health` endpoint
- **ECS Health Check**: Container health monitoring
- **Smoke Test**: Automated curl test after deployment

### Logging
- **ECS Logs**: Automatically sent to CloudWatch Logs
- **Application Logs**: Flask/Gunicorn logs via container logging

## Security Considerations

### Network Security
- ECS tasks run in private subnets
- ALB in public subnets with restricted security groups
- No direct internet access for application containers

### Access Control
- IAM roles with minimal required permissions
- ECR repository access controlled via IAM
- GitHub Actions use temporary AWS credentials

### Data Protection
- No persistent storage (stateless application)
- Environment variables for configuration
- Secure container image registry (ECR)

## Cost Optimization

### Resource Sizing
- Minimal Fargate configuration (256 CPU, 512 MB memory)
- Single NAT Gateway (not per-AZ)
- Appropriate security group rules

### Operational Efficiency
- Infrastructure as Code reduces manual errors
- Automated deployment reduces operational overhead
- Container-based deployment enables rapid scaling

## Scalability Considerations

### Horizontal Scaling
- ECS service can be easily scaled up/down
- ALB automatically distributes traffic
- Multiple AZs for high availability

### Vertical Scaling
- Task definition can be updated for more CPU/memory
- Fargate supports up to 4 vCPU and 30 GB memory

### Future Enhancements
- Auto Scaling Groups for dynamic scaling
- Application Load Balancer with HTTPS/SSL
- CloudFront CDN for global distribution
- RDS database for persistent storage
- ElastiCache for caching
- CloudWatch monitoring and alerting
