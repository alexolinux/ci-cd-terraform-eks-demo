pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION    = credentials('AWS_DEFAULT_REGION')
    }

    stages {
        stage("Create EKS Cluster") {
            steps {
                script {
                    dir('eks') {
                        // Initialize Terraform
                        sh "terraform init"
                        // Apply Terraform changes (create EKS cluster)
                        sh "terraform apply -auto-approve"
                    }
                }
            }
        }

        stage("Deploy to EKS") {
            steps {
                script {
                    // Change to the directory containing Kubernetes manifests
                    dir('eks/kubernetes') {
                        // Configure kubectl to use the EKS cluster
                        sh "aws eks update-kubeconfig --name test-eks-cluster"
                        // Apply Kubernetes deployment/service
                        sh "kubectl apply -f nginx-deployment.yaml"
                        sh "kubectl apply -f nginx-service.yaml"
                    }
                }
            }
        }
    }
}
