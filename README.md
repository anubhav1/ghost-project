# Ghost Assessment

This repository provides a POC to deploy a Ghost webapp running on Nginx Server on three-tier aws infrastructure. It is built with high availability, scalibility and fault tolerance. On backend it is connected to MYSQL Database which has disaster recovery capabilities. This repository also contains a pipeline to deploy the infrastructure as part of CI/CD. No secrets and keys are hardcorded in the code.


# Features
1. Immune to spikes in traffic.
2. Cross-region DB Read-Replica for disaster recovery capabilities in case of a region failure.
3. Requests to Application Load Balancers are SSL Encrypted.
4. Supports custom domain names.
5. An API with lambda proxy in backend to delete all the posts from the Ghost Webapp. 
6. Logging is taken into account at multiple points in the infrastructure.   


# Architecuture 
![Alt text](images/main-architecutre.png?raw=true "Title")



# Directory Structure
The Directory follows the following structure:
![Alt text](images/directory.png?raw=true "Title")

# Deployment steps
1. Install Terraform on your local machine by following the [link](https://learn.hashicorp.com/tutorials/terraform/install-cli). Minimum version required is `1.2.8`.
2. Install git and configure it in your local machine by following the [link](https://github.com/git-guides/install-git).
3. Install aws cli v2 and configure the `default` profile by following the [link](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
4. Go to `pipelines/dev` folder and provide the values to the variables in `terraform.tfvars` file.
5. Come back to `pipelines` folder and run following commands:
   ```
   terraform init
   terraform plan -var-file="dev/terraform.tfvars"
   terraform apply -var-file="dev/terraform.tfvars"
   ```
6. It will create the pipeline in your specified region.
7. Create db credentials in json form `{"username":"xxxx", "password": "xxxx"}` in secret manager. Secret type should be `Other type of secret`. Password should be min. 12 characters long.
8. Similary Create ghost admin api key in json form `{"api-key": "xxxx"}` in secret manager. Secret type should be `Other type of secret`.
9. Create Route 53 hosted zone for your domain name. 
10. Now come to the `/dev` folder of root directory and provide the values to the variables in `terraform.tfvars` file.Makes sure value of the `region` is the same which you provided in `pipelines/dev/terraform.tfvars` file .
11. Push the contents inside the directory in github.
12. This will trigger the pipeline and deploy the three-tier architecture in the same region.

For every change in the infrastrucure repeat steps 8-9.


# Improvements
1. Cloudfront with WAF can be used for cache and DDoS attacks and make the website avaliable only via Cloudfront by using custom header.
2. API can have an cognito authorizer.
3. EFS can be used as shared drive among EC2 instances which might solve the problem of high availibility.