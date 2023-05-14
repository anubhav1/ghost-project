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
  //profile = "main-admin"  
  region  = "${var.primary_region}"
}

# Specifies the S3 Bucket and DynamoDB table used for the durable backend and state locking
terraform {
    backend "s3" {
      encrypt = true
      bucket = "ghost-tf-state-bucket78277"
      dynamodb_table = "tf-state-lock-db"
      key = "path/path/terraform.tfstate"
      region = "eu-central-1"   
  }
}











 

 

















