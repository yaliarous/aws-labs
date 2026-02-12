# ALB + ASG Lab (Terraform)

This lab provisions a simple web tier on AWS using Terraform:
- A VPC with public and private subnets across 3 AZs
- An internet-facing Application Load Balancer (ALB)
- An Auto Scaling Group (ASG) of Ubuntu instances in private subnets
- Nginx installed at boot via `user_data.sh`
- IAM role + instance profile for AWS Systems Manager (SSM)

## Architecture
- `module.alb_lab_vpc` creates networking (VPC, subnets, IGW, single NAT gateway)
- `aws_lb` listens on HTTP/80 in public subnets
- `aws_autoscaling_group` launches instances from `aws_launch_template` in private subnets
- `aws_autoscaling_attachment` registers ASG instances to the ALB target group

## Prerequisites
- Terraform installed
- AWS credentials configured (`aws configure`, environment variables, or profile)
- Permissions to create VPC, EC2, ALB, Auto Scaling, IAM resources

## Usage
Run from this folder:

```bash
terraform init
terraform plan
terraform apply
```

After apply, open the `elb_dns` output in a browser.

## Variables (defaults)
| Name | Default |
| --- | --- |
| `region` | `us-east-1` |
| `instance_type` | `t2.micro` |
| `asg_min_size` | `1` |
| `asg_desired_capacity` | `2` |
| `asg_max_size` | `3` |
| `enable_deletion_protection` | `true` |

Note: `instance_count` exists in `variable.tf` but is not used by the current ASG-based configuration.

## Outputs
| Name | Description |
| --- | --- |
| `elb_dns` | DNS name of the load balancer |

## Cleanup
```bash
terraform destroy
```

If destroy fails because of ALB deletion protection:
1. Set `enable_deletion_protection = false`
2. Run `terraform apply`
3. Run `terraform destroy` again

## Files
- `ALB.tf`: ALB, target group, listener, ALB security group
- `ASG.tf`: Launch template, Auto Scaling Group, target group attachment, instance security group, IAM role/profile
- `network.tf`: VPC module configuration
- `output.tf`: Outputs
- `provider.tf`: AWS provider and default tags
- `variable.tf`: Input variables
- `user_data.sh`: Installs and starts Nginx
