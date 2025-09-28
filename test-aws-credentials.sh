#!/bin/bash
# Test AWS credentials and permissions

echo "Testing AWS credentials..."

# Test basic AWS access
echo "1. Testing AWS CLI access..."
aws sts get-caller-identity

# Test specific permissions needed for our infrastructure
echo "2. Testing VPC permissions..."
aws ec2 describe-vpcs --max-items 1

echo "3. Testing ECS permissions..."
aws ecs list-clusters --max-items 1

echo "4. Testing ECR permissions..."
aws ecr describe-repositories --max-items 1

echo "5. Testing IAM permissions..."
aws iam get-user

echo "✅ AWS credentials test completed!"
