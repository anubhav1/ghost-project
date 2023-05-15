env_prefix = "dev"
primary_region = "eu-central-1"
tf_state_save_bucket = "ghost-tf-state-bucket7827"
tf_state_lock_db = "tf-state-lock-db"
vpc_name = "GhostVPC"
vpc_cidr = "10.0.0.0/16"
primary_region_azs = ["eu-central-1a", "eu-central-1b"]
secondary_region_azs = ["us-east-1a", "us-east-1b"]
public_subnet_A_cidr = "10.0.1.0/24"
public_subnet_B_cidr = "10.0.2.0/24"
application_subnet_A_cidr = "10.0.3.0/24"
application_subnet_B_cidr = "10.0.4.0/24"
ami_id = "ami-03aefa83246f44ef2"
ec2_ssm_profile ="ec2_ssm_custom_profile"
ec2_ssm_role = "ec2_ssm_custom_role"
instance_type = "t2.micro"
key_name = "ghost"
cpu_target_value = "60"
route53_zone_id = "Z01258572IO1N8GSDQZPM"
route53_record_name = "t4.pada.tk"
