# Test AWS credentials and permissions (PowerShell version)

Write-Host "Testing AWS credentials..." -ForegroundColor Green

# Test basic AWS access
Write-Host "1. Testing AWS CLI access..." -ForegroundColor Yellow
try {
    $identity = aws sts get-caller-identity
    Write-Host "✅ AWS CLI access successful" -ForegroundColor Green
    Write-Host $identity
} catch {
    Write-Host "❌ AWS CLI access failed" -ForegroundColor Red
    Write-Host "Error: $_" -ForegroundColor Red
}

# Test specific permissions needed for our infrastructure
Write-Host "`n2. Testing VPC permissions..." -ForegroundColor Yellow
try {
    aws ec2 describe-vpcs --max-items 1
    Write-Host "✅ VPC permissions OK" -ForegroundColor Green
} catch {
    Write-Host "❌ VPC permissions failed" -ForegroundColor Red
}

Write-Host "`n3. Testing ECS permissions..." -ForegroundColor Yellow
try {
    aws ecs list-clusters --max-items 1
    Write-Host "✅ ECS permissions OK" -ForegroundColor Green
} catch {
    Write-Host "❌ ECS permissions failed" -ForegroundColor Red
}

Write-Host "`n4. Testing ECR permissions..." -ForegroundColor Yellow
try {
    aws ecr describe-repositories --max-items 1
    Write-Host "✅ ECR permissions OK" -ForegroundColor Green
} catch {
    Write-Host "❌ ECR permissions failed" -ForegroundColor Red
}

Write-Host "`n5. Testing IAM permissions..." -ForegroundColor Yellow
try {
    aws iam get-user
    Write-Host "✅ IAM permissions OK" -ForegroundColor Green
} catch {
    Write-Host "❌ IAM permissions failed" -ForegroundColor Red
}

Write-Host "`n✅ AWS credentials test completed!" -ForegroundColor Green
