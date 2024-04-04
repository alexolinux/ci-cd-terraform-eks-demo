#-- ec2 Vars
variable "public_key" {
  description = "SSH Public String Key Pair"
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK1CjAysvZdq5Ch/as4s8R/wvXvWMwpP1V5VPMSkO5KH"
}

variable "instance_type" {
  description = "ec2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "volume_size" {
  description = ""
  type        = number
  default     = 8
}

#https://docs.aws.amazon.com/ebs/latest/userguide/ebs-volume-types.html
variable "volume_type" {
  description = "EBS Volume types"
  type        = string
  default     = "gp3"
}

variable "delete_on_termination" {
  description = "Delete EBS Volume when ec2 is terminated"
  type        = bool
  default     = true
}

variable "monitoring" {
  description = "EC2 monitoring"
  type        = bool
  default     = false
}

variable "ebs_optimized" {
  description = "EBS volume optimization"
  type        = bool
  default     = true
}

variable "encrypted" {
  description = "EBS block encryption"
  type        = bool
  default     = true
}

#Variables group_name, user_name, private_key
#are recommended to be defined in override.tf
#override.tf is included in .gitignore for "sensitive data" protection
variable "group_name" {
  description = "Linux Group"
  type        = string
  default     = null
}

variable "user_name" {
  description = "Linux User"
  type        = string
  default     = null
}

variable "private_key" {
  description = "Path to the private SSH key file"
  type        = string
  sensitive   = true
  default     = null
}

#-- Tag Vars
variable "tags" {
  type = map(string)
  default = {
    environment = "test"
    managed     = "terraform"
    createdby   = "devops"
  }
}
