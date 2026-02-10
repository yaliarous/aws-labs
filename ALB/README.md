# ALB Lab (Terraform)

This lab provisions a basic web tier behind an Application Load Balancer (ALB) on AWS using Terraform. It creates a VPC with public and private subnets, a NAT gateway, an ALB in public subnets, and Ubuntu EC2 instances in private subnets running Nginx.

## What It Creates
- VPC with 3 public and 3 private subnets across three AZs
- Internet gateway and a single NAT gateway
- ALB with HTTP listener and target group
- Security groups for the ALB and web instances
- Ubuntu 22.04 EC2 instances running Nginx via `user_data.sh`
- IAM role + instance profile for SSM access

## Prerequisites
- Terraform installed
- AWS credentials configured (for example via `aws configure`, environment variables, or an AWS profile)
- Access to create VPC, EC2, ALB, IAM, and related resources in the target account

## Usage
From this folder:
```bash
terraform init
terraform plan
terraform apply
```

After apply, use the output `elb_dns` to access the Nginx page through the ALB.

## Cleanup
```bash
terraform destroy
```

Note: `enable_deletion_protection` defaults to `true`. If destroy fails, set it to `false` and apply again before destroying.


## Outputs
| Name | Description |
| --- | --- |
| `elb_dns` | DNS name of the load balancer |

## Files
- `ALB.tf`: ALB, target group, listener, and ALB security group
- `EC2.tf`: Web EC2 instances, AMI lookup, instance role/profile
- `network.tf`: VPC module configuration
- `output.tf`: Outputs
- `provider.tf`: AWS provider
- `variable.tf`: Input variables
- `user_data.sh`: Installs and starts Nginx
