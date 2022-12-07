#!/usr/bin/zsh

if [ "$1" = "init" ]
then
    terraform init -backend-config=./config/config.s3.tfbackend
elif [ "$1" = "reinit" ]
then
    terraform init -reconfigure -backend-config=./config/config.s3.tfbackend
elif [ "$1" = "plan" ]
then
    terraform plan -out=tf.plan -var-file=./config/balin-lab.tfvars
elif [ "$1" = "apply" ]
then
    terraform apply tf.plan
elif [ "$1" = "destroy" ]
then
    terraform destroy -var-file=./config/balin-lab.tfvars
else
    echo "Argument Error!!"
fi