#!/bin/bash
# Script to get the live demo URL after successful deployment

echo "🚀 Getting CI/CD Infrastructure Demo URL..."
echo ""

# Check if AWS CLI is configured
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI is not installed or not in PATH"
    echo "Please install AWS CLI and configure your credentials"
    exit 1
fi

# Get the ALB DNS name from Terraform outputs
echo "📋 Retrieving ALB DNS name from Terraform..."

cd terraform

# Check if terraform is initialized
if [ ! -d ".terraform" ]; then
    echo "❌ Terraform not initialized. Please run 'terraform init' first"
    exit 1
fi

# Get the ALB DNS name
ALB_DNS=$(terraform output -raw alb_dns_name 2>/dev/null)

if [ -z "$ALB_DNS" ]; then
    echo "❌ Could not retrieve ALB DNS name"
    echo "Make sure your infrastructure is deployed successfully"
    echo "Run: terraform output -json to see all outputs"
    exit 1
fi

echo "✅ ALB DNS Name: $ALB_DNS"
echo ""

# Test if the application is responding
echo "🔍 Testing application health..."
HEALTH_URL="http://$ALB_DNS/health"
MAIN_URL="http://$ALB_DNS/"

echo "Testing health endpoint: $HEALTH_URL"
if curl -s --fail "$HEALTH_URL" > /dev/null; then
    echo "✅ Application is healthy and responding!"
    echo ""
    echo "🎉 Your CI/CD Infrastructure is live!"
    echo ""
    echo "🔗 Live Demo URLs:"
    echo "   Main Application: $MAIN_URL"
    echo "   Health Check:     $HEALTH_URL"
    echo ""
    echo "📝 Update your portfolio with these URLs:"
    echo "   Replace 'http://YOUR_ALB_DNS_NAME_HERE' with: $MAIN_URL"
    echo ""
    echo "📊 Application Status:"
    echo "   ✅ Infrastructure: Deployed"
    echo "   ✅ Application: Running"
    echo "   ✅ Health Check: Passing"
    echo "   ✅ Load Balancer: Active"
else
    echo "⚠️  Application is deployed but not responding to health checks"
    echo "This might be normal if the application is still starting up"
    echo "Try again in a few minutes"
    echo ""
    echo "🔗 URLs (may not be ready yet):"
    echo "   Main Application: $MAIN_URL"
    echo "   Health Check:     $HEALTH_URL"
fi

echo ""
echo "📋 Additional Information:"
echo "   ECS Cluster: $(terraform output -raw cluster_name 2>/dev/null || echo 'Not available')"
echo "   ECS Service: $(terraform output -raw service_name 2>/dev/null || echo 'Not available')"
echo "   ECR Repository: $(terraform output -raw ecr_repo_url 2>/dev/null || echo 'Not available')"
