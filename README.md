# WRI Serverless Deployment (`wri-serverless-deploy`)

## Overview

The `wri-serverless-deploy` project is dedicated to deploying and managing a custom GDAL+EMR Serverless application. This project includes a Terraform management script, `tf`, and a Python CLI script for job submission on EMR Serverless. The `tf` script streamlines Terraform operations and manages multiple environments through Terraform workspaces, while the Python CLI script facilitates submitting Spark jobs to EMR Serverless.

## Key Components

- **Terraform Script (`tf`)**: Simplifies operations and manages infrastructure for the GDAL+EMR Serverless application using Terraform.
- **Workspace Management**: Utilizes Terraform workspaces for clear separation of environments such as `dev`, `prod`, etc.
- **Docker Integration**: Handles building and pushing Docker images necessary for the serverless application.
- **EMR Serverless Job Submission Script**: A Python CLI tool for submitting Spark jobs to AWS EMR Serverless.

## Prerequisites

- Terraform (compatible version)
- Docker (for image building and pushing)
- AWS CLI (configured for access to AWS services)
- Python with `boto3` (for running the EMR Serverless job submission script)
- Understanding of GDAL, EMR, and serverless concepts

## Usage

### Terraform Script (`tf`)

Execute Terraform commands within the project's infrastructure context:

```bash
./tf [terraform_command] [options]
```

Examples:

```bash
./tf plan
./tf apply
./tf destroy
```

### Managing Workspaces

Manage different deployment environments using workspaces. Automatically selects the appropriate variable file for the active workspace:

```bash
./tf workspace new [workspace_name]
./tf workspace select [workspace_name]
```

### Docker Image Management

Build and push Docker images as part of the infrastructure setup:

```bash
./tf update_image
```

### EMR Serverless Job Submission Script

Submit Spark jobs to EMR Serverless using the Python CLI script:

```bash
python emr_job_cli.py \
  --application-id "app-id" \
  --execution-role-arn "arn:aws:iam::123456789012:role/MyRole" \
  --entry-point "s3://path/to/your/script.py" \
  --entry-point-arguments "arg1 arg2 arg3" \
  --spark-submit-parameters "--executor-memory 1G --total-executor-cores 2" \
  --name "MySparkJob"
```

Replace the placeholders with actual job details. `entryPointArguments` should be a space-separated list of arguments.

### Deployment Process

0. **Backend setup** S3 backed terraform deployments allow us to keep the state file out of version control. `infra/setup_backend.sh` does this in an idempotent fashion, so it should be safe for use in CI/CD.
1. **Initialize**: Automatically initializes the Terraform environment.
2. **Workspace Selection**: Select or create a workspace for your target environment.
3. **Plan and Apply**: Review and apply Terraform configurations to deploy the GDAL+EMR Serverless application.

## Contributing

Enhance the deployment process, add features, or improve the GDAL+EMR Serverless application:

1. Fork the repository.
2. Create a feature branch.
3. Commit your changes.
4. Create a pull request.

## Important Notes

- **Variable Files**: Ensure workspace-specific variable files are correctly named and located in the `./infra` directory. These can live in version control for use in CI/CD
- **Credentials and Secrets**: Handle AWS credentials and sensitive data securely, especially when using the job submission script.