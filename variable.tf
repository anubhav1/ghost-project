variable "env_prefix" {
  description = "Env Prefix"
  type        = string
}

variable "primary_region" {
  description = "Primary Region"
  type        = string
}


variable "tf_state_save_bucket" {
  description = "TF State Save Bucket"
  type        = string
}

variable "tf_state_lock_db" {
  description = "TF State Lock DB"
  type        = string
}
variable "vpc_name" {
  description = "VPC name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR range"
  type        = string
  //default     = "10.0.0.0/16"
}

variable "primary_region_azs" {
  description = "Availability Zones"
  type        = list
  default     = ["eu-central-1a", "eu-central-1b"] 
}

variable "secondary_region_azs" {
  description = "Availability Zones in Secondary Region"
  type        = list
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_A_cidr" {
  description = "Public subnets"
  type        = string
  //default     = "10.0.1.0/24"
}

variable "public_subnet_B_cidr" {
  description = "Public subnets"
  type        = string
 // default     = "10.0.2.0/24"
}

variable "application_subnet_A_cidr" {
  description = "App subnets"
  type        = string
  //default     = "10.0.3.0/24"
}

variable "application_subnet_B_cidr" {
  description = "App subnets"
  type        = string
  //default     = "10.0.4.0/24"
}

variable "database_subnet_A_cidr" {
  description = "DB subnets"
  type        = string
 // default     = "10.0.5.0/24"
}

variable "database_subnet_B_cidr" {
  description = "DB subnets"
  type        = string
  // default     = "10.0.6.0/24"
}

variable "ami_id" {
  description = "AMI ID"
  type        = string
}

variable "ec2_ssm_profile" {
  description = "EC2 SSM Custom Profile"
  type        = string
}

variable "ec2_ssm_role" {
  description = "EC2 SSM Custom Role"
  type        = string
}
variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
}

variable "key_name" {
  description = "EC2 SSH Key Name"
  type        = string
}

variable "cpu_target_value" {
  description = "Cpu Utilization Target Value"
  type        = string
}

variable "rds_allocated_storage" {
  description = "RDS Allocated Storage"
  type        = number
}

variable "rds_identifier" {
  description = "RDS Identifier"
  type        = string
}
variable "rds_read_replica_identifier" {
  description = "RDS Identifier"
  type        = string
}
variable "rds_engine" {
  description = "RDS Engine"
  type        = string
  default = "mysql"
}
variable "rds_engine_version" {
  description = "RDS Engine Version"
  type        = string
  default = "8.0.28"
}
variable "rds_instance_class" {
  description = "RDS Instance Class"
  type        = string
  default = "db.t3.micro"
}
variable "rds_db_name" {
  description = "RDS DB Name"
  type        = string
}

variable "rds_secret_id" {
  description = "RDS Secret ID"
  type        = string
}

variable "route53_zone_id" {
  description = "route53 Zone Id"
  type        = string
}

variable "route53_record_name" {
  description = "route53 Record Name"
  type        = string
}

variable "api_stage_name" {
  description = "Api Stage Name"
  type        = string
}

variable "lambda_bucket_name" {
  description = "Lambda Bucket Name"
  type        = string
}

variable "ghost_admin_api_secret" {
  description = "Ghost Admin Api Secret Name"
  type        = string
}



