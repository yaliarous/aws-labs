variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "instance_count" {
  type    = number
  default = 2
}

variable "enable_deletion_protection" {
  type    = bool
  default = false
}

variable "asg_max_size" {
  type    = number
  default = 3
}

variable "asg_min_size" {
  type    = number
  default = 1
}

variable "asg_desired_capacity" {
  type    = number
  default = 2
}