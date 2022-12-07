## About the project
- Use Terraform to build a infrastructure with AWS provider.
- You will build a infrastructure with nginx based on EC2 instance and load balancer.
- You can access your `<subdomain name>.<domain name>` with http and https to see the nginx welcome page after applying the code and waiting around 10 minutes.
![image](https://adc.github.trendmicro.com/balin-lin/terraform-tutorial/blob/main/AWS%20Lab%20Architecture.png)

## Terraform command to run this project
```bash
# init manually
terraform init -backend-config="bucket=<S3_BUCKET_NAME>" -backend-config="key=<TERRAFORM_STATE_LOCATION>" -backend-config="region=<AWS_REGION>" -backend-config="profile=<AWS_PROFILE>"

# init with file
terraform init -backend-config=./config/config.s3.tfbackend

# show change and plan file
terraform plan -out=tf.plan -var-file=config/<VARIABLE_FILE>

# apply with .plan
terraform apply tf.plan
```

## Shell command to run this project
```bash
# init
zsh run.sh init

# show change and plan file
zsh run.sh plan

# apply with .plan
zsh run.sh apply

# destroy
zsh run.sh destroy
```