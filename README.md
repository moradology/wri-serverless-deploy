# WRI Serverless Deployment (`wri-serverless-deploy`)

## Overview

The `wri-serverless-deploy` project is designed for deploying and managing a custom GDAL+EMR Serverless application. This project includes a script, `tf`, which facilitates the deployment and management of infrastructure resources using Terraform. The script streamlines the execution of Terraform commands and manages multiple environments through Terraform workspaces.

## Key Components

- **Terraform Script (`tf`)**: Simplifies Terraform operations and manages infrastructure for the GDAL+EMR Serverless application.
- **Workspace Management**: Utilizes Terraform workspaces for clear separation of environments like `dev`, `prod`, etc.
- **Docker Integration**: Automates the building and pushing of Docker images necessary for the serverless application.

## Prerequisites

- Terraform (compatible version)
- Docker (for image building and pushing)
- AWS CLI (configured for access to AWS services)
- Understanding of GDAL, EMR, and serverless concepts

## Usage

### Terraform Script (`tf`)

The `tf` script is used to execute Terraform commands within the context of the project's infrastructure.

```bash
./tf [terraform_command] [options]
```

Example:

```bash
./tf plan
./tf apply
./tf destroy
```

### Managing Workspaces

Workspaces allow for managing different deployment environments. The script automatically selects the appropriate variable file for the active workspace.

Create a new workspace:

```bash
./tf workspace new [workspace_name]
```

Switch to an existing workspace:

```bash
./tf workspace select [workspace_name]
```

### Docker Image Management

As part of the infrastructure setup, Docker images are built and pushed. This is integrated into the Terraform apply process managed by the `tf` script.

Push an updated docker image:

```bash
./tf update_image
```

### Deployment Process

1. **Initialize**: Initialize the Terraform environment (done automatically by the `tf` script).
2. **Workspace Selection**: Select or create a workspace corresponding to your target environment.
3. **Plan and Apply**: Review and apply Terraform configurations to deploy the GDAL+EMR Serverless application.

## Contributing

Contributions are welcome to enhance the deployment process, add features, or improve the GDAL+EMR Serverless application.

1. Fork the repository.
2. Create a feature branch.
3. Commit your changes.
4. Create a pull request.

## Important Notes

- **Variable Files**: Ensure workspace-specific variable files are correctly named and located in the `./infra` directory.