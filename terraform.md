# command cheatsheet

```
terraform init    # Initialize the current directory
terraform plan    # Dry run to see what Terraform will do
terraform apply   # Apply the Terraform code and build stuff
terraform destroy # Destroy what was built by Terraform
terraform refresh # Refresh the state file
terraform output  # View Terraform outputs
terraform graph   # Create a DOT-formatted graph
```

# terraform states
| Configuration | State | Reality | Operation |
| --- | --- | --- | --- |
| aws_instance |     |     | create |
| aws_instance | aws_instance |     | create |
| aws_instance | aws_instance | aws_instance | no-op |
|     | aws_instance | aws_instance | delete |
|     |     | aws_instance | no-op |
|     | aws_instance |     | update state |
