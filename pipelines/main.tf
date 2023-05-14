terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.8"
}

provider "aws" {
  //alias  = "primary"
  profile = "default"  
  region  = "${var.region}"
}

# ## Specifies the S3 Bucket and DynamoDB table used for the durable backend and state locking
# terraform {
#     backend "s3" {
#       encrypt = true
#       bucket = aws_s3_bucket.my-tf-test-bucket7827.name
#       dynamodb_table = aws_dynamodb_table.terraform-state-lock-dynamo.name
#       key = "path/path/terraform.tfstate"
#       region = "eu-central-1"
#   }
# }

resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "${var.codepipeline_artifacts_bucket}"
  tags = {
    Name        = "My bucket"
  }
}


resource "aws_codepipeline" "ghost-codepipeline" {
  name     = "ghost-codepipeline"
  role_arn = aws_iam_role.codepipeline-role.arn
  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }
  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["SourceArtifact"]
      
      configuration = {
       // ConnectionArn        = "${var.codestar_connection_arn}"
        Owner                = "${var.github_organization}"
        Repo                 = "${var.github_repository}"
        Branch               = "${var.github_branch}"
        OAuthToken           = ""
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      version          = "1"

      configuration = {
        ProjectName = "Ghost-Build"
      }
    }
  }
}


resource "aws_codebuild_project" "ghost-build" {
  name          = "Ghost-Build"
  description   = "Ghost-Build"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "TF_COMMAND"
      value = "${var.tf_command}"
    }

  source {
    type            = "CODEPIPELINE"
  }
  source_version = "master"

}
}




resource "random_string" "github_secret" {
  length  = 99
  special = false
}

resource "aws_codepipeline_webhook" "aws_webhook" {
  name            = "aws_webhook"
  authentication  = "GITHUB_HMAC"
  target_action   = "Source"
  target_pipeline = aws_codepipeline.ghost-codepipeline.name
  authentication_configuration {
    secret_token = random_string.github_secret.result
  }
  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/{Branch}"
  }
}


# Wire the CodePipeline webhook into a GitHub repository.
resource "github_repository_webhook" "github-webhook" {
  repository = "${var.github_repository}"
  //name = "web"
  configuration {
    url          = aws_codepipeline_webhook.aws_webhook.url
    content_type = "json"
    insecure_ssl = true
    secret       = random_string.github_secret.result
  }
  events = ["push"]
}

resource "aws_iam_role" "codepipeline-role" {
  name = "codepipeline-role"

  assume_role_policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
  })
}

resource "aws_iam_role" "codebuild-role" {
  name = "codebuild-role"

  assume_role_policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
  })
}


resource "aws_iam_role_policy" "codepipeline-policy" {
  name = "codepipeline_policy"
  role = aws_iam_role.codepipeline-role.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
})
}

resource "aws_iam_role_policy" "codebuild-policy" {
  name = "codebuild_policy"
  role = aws_iam_role.codebuild-role.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
})
}

