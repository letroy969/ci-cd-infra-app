#!/bin/bash
# Test Terraform commands locally to reproduce the issue

echo "=== LOCAL TERRAFORM TEST ==="
echo "Testing Terraform commands that are failing in GitHub Actions"
echo ""

# Check if we're in the right directory
echo "Current directory: $(pwd)"
echo "Terraform directory contents:"
ls -la terraform/

echo ""
echo "=== TESTING TERRAFORM COMMANDS ==="

cd terraform

echo "1. Testing terraform init..."
terraform init -input=false -no-color
INIT_EXIT_CODE=$?
echo "terraform init exit code: $INIT_EXIT_CODE"

if [ $INIT_EXIT_CODE -ne 0 ]; then
    echo "❌ terraform init failed"
    exit 1
fi

echo ""
echo "2. Testing terraform validate..."
terraform validate -no-color
VALIDATE_EXIT_CODE=$?
echo "terraform validate exit code: $VALIDATE_EXIT_CODE"

if [ $VALIDATE_EXIT_CODE -ne 0 ]; then
    echo "❌ terraform validate failed"
    exit 1
fi

echo ""
echo "3. Testing terraform plan..."
terraform plan -no-color \
  -var="app_name=ci-cd-app" \
  -var="aws_region=us-east-1" \
  -var="desired_count=0"
PLAN_EXIT_CODE=$?
echo "terraform plan exit code: $PLAN_EXIT_CODE"

if [ $PLAN_EXIT_CODE -eq 1 ]; then
    echo "❌ terraform plan failed with error"
    exit 1
elif [ $PLAN_EXIT_CODE -eq 2 ]; then
    echo "✅ terraform plan shows changes to apply"
else
    echo "✅ terraform plan shows no changes"
fi

echo ""
echo "4. Testing terraform apply (DRY RUN - will not actually apply)..."
echo "Note: This is a dry run test - no actual resources will be created"
echo "Run with -target=random_id.test to test without creating real resources"

echo ""
echo "=== LOCAL TEST COMPLETED ==="
echo "If all steps above succeeded, the issue might be with:"
echo "- GitHub Secrets configuration"
echo "- AWS credentials permissions"
echo "- GitHub Actions environment"
