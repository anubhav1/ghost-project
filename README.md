# Ghost Assessment

This repository provides a POC to deploy a Ghost webapp running inside two-tier aws infrastructure. It is built with high availability, scalibility and fault tolerance. This repository also contains a pipeline to deploy the infrastructure as part of CI/CD. No secrets and keys are hardcorded in the code.

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
5. Create a S3 bucket and a dynamo db table to save terraform states and provide those names in `project>pipelines>main.tf` inside `terraform` block.
6. Come back to `pipelines` folder and run following commands:
   ```
   terraform init
   terraform plan -var-file="dev/terraform.tfvars"
   terraform apply -var-file="dev/terraform.tfvars"
   ```
7. It will create the pipeline in your specified region. 
8.  Now come to the `/dev` folder of root directory and provide the values to the variables in `terraform.tfvars` file. Makes sure value of the `region` is the same which you provided in `pipelines/dev/terraform.tfvars` file .
9.  Push the contents inside the directory in github.
10. This will trigger the pipeline and deploy the three-tier architecture in the same region.

For every change in the infrastrucure repeat steps 8-9.


# Improvements
1. Cloudfront with WAF can be used for cache and DDoS attacks and make the website avaliable only via Cloudfront by using custom header.
2. Custom domain names can be used instead of default aws dns names.