pipeline {
    agent any // Runs on any available Jenkins agent

    tools {
        // This 'Terraform' must match the name you configure in Jenkins Global Tool Configuration
        terraform 'Terraform'
    }

    environment {
        // We will load these secrets from the Jenkins credentials store
        TF_VAR_pm_api_token_id    = credentials('PROXMOX_API_TOKEN_ID')
        TF_VAR_pm_api_token_secret = credentials('PROXMOX_API_TOKEN_SECRET')
        TF_VAR_pm_api_url         = "https://192.168.31.180:8006/api2/json"
    }

    stages {
        stage('Checkout') {
            steps {
                // Pulls the code from your GitHub repo
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                // Initializes Terraform and downloads the proxmox provider
                bat 'terraform init -upgrade'
            }
        }

        stage('Terraform Plan') {
            steps {
                // Creates an execution plan
                bat 'terraform plan -out=tfplan'
            }
        }

        stage('Apply') {
            steps {
                timeout(time: 15, unit: 'MINUTES') {
                    input message: 'Do you want to apply the Terraform plan?'
                }
                
                // If approved, applies the plan to build the VM
                bat 'terraform apply -auto-approve tfplan'
            }
        }
    }
}
