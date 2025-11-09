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
        
        // This is a non-secret variable, so we set it directly
        TF_VAR_pm_api_url         = "https://192.168.31.180:8006/api2/json" // CHANGE THIS
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
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                // Creates an execution plan
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Apply') {
            steps {
                // This 'input' step makes Jenkins PAUSE and wait for a human
                // to click "Proceed". This is a crucial safety check.
                timeout(time: 15, unit: 'MINUTES') {
                    input message: 'Do you want to apply the Terraform plan?'
                }
                
                // If approved, applies the plan to build the VM
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }
}
