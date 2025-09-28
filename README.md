# CI/CD Pipeline with IaC (Terraform + GitHub Actions -> AWS ECS Fargate)

Short: Provision AWS infra with Terraform and deploy a containerized Flask app through GitHub Actions.

Key commands:
- Local test infra apply (dev): `cd terraform && terraform init && terraform apply -var "aws_region=YOUR_AWS_REGION" -var "app_name=ci-cd-app" -var "desired_count=0" -auto-approve`
- Local destroy: `cd terraform && terraform destroy -var "aws_region=YOUR_AWS_REGION" -var "app_name=ci-cd-app" -auto-approve`

See .github/workflows/deploy.yml for CI/CD logic.
