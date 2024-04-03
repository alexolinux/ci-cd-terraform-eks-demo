# ci-cd-terraform-eks-demo

Deploy to EKS using terraform and Jenkins

---
This repository is a result of lab for EKS provisioning using Jenkins CI/CD.

- **vpc**

  Contains terraform code for VPC provisioning:
  
  - private_subnets (attached NAT Gateway)
  - public_subnets
  - database_subnets (private)

- **ec2**

  Provision an ec2 Instance in a public subnet using terraform.
  
  - Allowed Ports 22 and 8080 (Security Group)

- **eks**

  Provision eks cluster using terraform eks module.
