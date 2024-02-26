# aws-instance-refresh
Provision aws infrastructure with Terrafrom and trigger instance refresh.

## Prerequisites 
- Install Terraform
- AWS credentials with AmazonEC2FullAccess and Amazons3FullAccess

## Setup AWS credentials locally

Following command allows you to setup aws credetial locally.

```
aws configure
```

## Download Code

```
git clone https://github.com/kroshantha/aws-instance-refresh.git
cd aws-instance-refresh
terraform init
terraform plan
terraform apply -auto-approve
```
---

## VPC:
![vpc!](Images/diag.png)

## Trigger instance refresh

Change contents in index.html to view updated chnages after instance refresh.
Example: 
```
<h1>Increment and Decrement counter</h1> to
<h1>INCREMENT AND DECRMENT COUNTER</h1>
```

Copy the updated index.html to s3
```
aws s3 ls
aws s3 cp s3://${your_bucket_name}/index.html /usr/share/nginx/html/index.html
```

Trigger instance refresh
```
aws autoscaling start-instance-refresh --auto-scaling-group-name $Your_ASG_NAME --cli-input-json file://in_refresh.json
```
