variable "aws_region" {
  description = "AWS region for the assignment infrastructure."
  type        = string
  default     = "ap-south-1"
}

variable "aws_profile" {
  description = "AWS CLI profile; null uses the standard credential chain."
  type        = string
  default     = null
  nullable    = true
}

variable "project_name" {
  description = "Name prefix and Project tag value."
  type        = string
  default     = "ecommerce-microservices"
}

variable "admin_cidr" {
  description = "Administrator public IPv4 CIDR allowed to use SSH."
  type        = string

  validation {
    condition     = can(cidrhost(var.admin_cidr, 0)) && var.admin_cidr != "0.0.0.0/0"
    error_message = "admin_cidr must be a valid restricted CIDR, not 0.0.0.0/0."
  }
}

variable "key_name" {
  description = "Existing EC2 key-pair name in the selected region."
  type        = string
}

variable "dockerhub_username" {
  description = "Docker Hub namespace containing the five public application images."
  type        = string
  default     = "tabrezajazdc"
}

variable "image_tag" {
  description = "Tag shared by the five public Docker Hub images."
  type        = string
  default     = "latest"
}

variable "instance_type" {
  description = "EC2 size used to run the six containers."
  type        = string
  default     = "t3.small"
}
