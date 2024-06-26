variable "cluster_endpoint_public_access" {
  description = "EKS Public Endpoint"
  type        = bool
  default     = true
}

variable "instance_types" {
  description = "EKS Instance Types"
  type        = list(string)
  default     = ["t2.micro", "t2.medium", "t3.micro", "t3.medium"]
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
