resource "aws_emrserverless_application" "spark" {
  name                 = var.name
  type                 = "spark"
  release_label        = var.release_label

  image_configuration {
    image_uri          = var.image_uri
  }

  architecture         = var.architecture
  maximum_capacity {
    cpu                = var.max_cpu
    memory             = var.max_memory
  }

  network_configuration {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = var.emr_sg_ids
  }
  tags = {
    Name = "emr-spark"
    Terraform = true
  }
}

# Permissions for application jobs to run using custom ECR
data "aws_iam_policy_document" "emr_serverless_ecr_policy" {
  statement {
    sid    = "EmrServerlessCustomImageSupport_${var.ecr_repository_name}"
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = ["emr-serverless.amazonaws.com"]
    }

    actions = [
      "ecr:BatchGetImage",
      "ecr:DescribeImages",
      "ecr:GetDownloadUrlForLayer"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values = [aws_emrserverless_application.spark.arn]
    }
  }
}

resource "aws_ecr_repository_policy" "emr_serverless_ecr_policy" {
  repository = var.ecr_repository_name
  policy     = data.aws_iam_policy_document.emr_serverless_ecr_policy.json
}