# ci-cd-terraform-eks-demo

Deploy to EKS using Terraform and Jenkins

---
This repository results from a lab for EKS provisioning using Jenkins CI/CD.

- **vpc**

  Contains terraform code for VPC provisioning:
  
  - private_subnets (attached NAT Gateway)
  - public_subnets
  - database_subnets (private)

- **ec2**

  Provision an ec2 Instance in a public subnet using terraform.
  
  - Allowed Ports 22 and 8080 (Security Group)

  > After provisioned the EC2 Instance, run the following docker commands:

  1 Create a Jenkins volume
  
  ```shell
  docker volume create jenkins
  ```
  
  2 Run the Jenkins container named `jenkins-devops`

  ```shell
  docker run --name jenkins-devops -d -p 8080:8080 -p 50000:50000 -v jenkins:/var/jenkins_home alexmbarbosa/jenkins-devops:latest
  ```

  3 Get Jenkins initial password

  ```shell
  docker exec -it jenkins-devops cat /var/jenkins_home/secrets/initialAdminPassword
  ```

- **eks**

  Provision eks cluster using terraform eks module.
