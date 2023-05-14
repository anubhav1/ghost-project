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
  profile = "main-admin"  
  region  = "${var.primary_region}"
}


#Resources to save terraform states
resource "aws_dynamodb_table" "terraform-state-lock-dynamo" {
    name = "${var.tf_state_lock_db}"
    hash_key         = "LockID"
    billing_mode   = "PROVISIONED"
    read_capacity  = 20
    write_capacity = 20
    attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_s3_bucket" "terraform-state-save-bucket" {
  bucket = "${var.tf_state_save_bucket}"
  tags = {
    Name        = "My bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "terraform-state-save-bucket-block" {
  bucket = aws_s3_bucket.terraform-state-save-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

## Specifies the S3 Bucket and DynamoDB table used for the durable backend and state locking
# terraform {
#     backend "s3" {
#       encrypt = true
#       bucket = "${var.tf_state_save_bucket}"
#       dynamodb_table = "${var.tf_state_lock_db}"
#       key = "path/path/terraform.tfstate"
#       region = "${var.primary_region}"
#   }
# }











 

 

















