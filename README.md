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
  --entry-point "s3://path/to/assembly.jar" \
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

## Contributing and Pull Request Workflow

### Overview

To maintain the stability this project, we've established a specific workflow for contributions and pull requests (PRs). This process helps ensure that new changes are reviewed, tested, and integrated smoothly.

### Branches

- **`dev` Branch**: The default branch for ongoing development. All feature branches should be created from and made into `dev`.
- **`main` Branch**: The stable branch representing the production-ready state of our project. Merges into `main` are restricted to updates from `dev`.

### Pull Requests

1. **Creating PRs**:
   - When you're ready to contribute, create a feature branch from `dev`.
   - Once your feature or fix is ready, submit a pull request back into the `dev` branch.
   - The `dev` branch will serve as the integration branch for all development work.

2. **Review Process**:
   - PRs require review and approval before merging. Ensure that your code adheres to the project's standards and guidelines.
   - Address any feedback or required changes from the review process.

3. **Merging into `main`**:
   - Regularly, changes from `dev` are reviewed and merged into `main`.
   - PRs to `main` are restricted to merges from `dev` to ensure that only thoroughly tested and validated changes are deployed to production.
   - These merges are typically handled by the project maintainers.

### Automated Checks

- Our CI/CD pipeline includes checks to enforce this workflow.
- PRs attempting to merge into `main` from branches other than `dev` will be automatically flagged and blocked.

### Best Practices

- Keep your feature branches up-to-date with the latest changes from `dev`.
- Write clear, descriptive commit messages and PR descriptions.

## Important Notes

- **Variable Files**: Ensure workspace-specific variable files are correctly named and located in the `./infra` directory. These can live in version control for use in CI/CD
- **Credentials and Secrets**: Handle AWS credentials and sensitive data securely, especially when using the job submission script.