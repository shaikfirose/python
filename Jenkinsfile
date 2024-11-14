pipeline {
    agent any

    environment {
        AWS_CREDENTIALS_ID = jenkins  // Replace with your AWS credentials ID in Jenkins
        TERRAFORM_DIR = 'terraform'  // Path to Terraform files
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Checkout the Terraform configuration from source control
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${env.TERRAFORM_DIR}") {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: "${AWS_CREDENTIALS_ID}"]]) {
                        sh 'terraform init'
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("${env.TERRAFORM_DIR}") {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir("${env.TERRAFORM_DIR}") {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Output ALB DNS') {
            steps {
                script {
                    dir("${env.TERRAFORM_DIR}") {
                        def albDns = sh(script: "terraform output -raw load_balancer_dns", returnStdout: true).trim()
                        echo "Application Load Balancer DNS: http://${albDns}"
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()  // Clean up workspace after build
        }
    }
}
