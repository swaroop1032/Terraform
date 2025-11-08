pipeline {
  agent any

  environment {
    TF_IN_AUTOMATION = "1"
    PM_API_URL = "https://192.168.31.180:8006/api2/json"   // replace if needed
    PM_API_TOKEN_ID = "terraform@pam!tf-token"            // replace if needed
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Terraform Init & Plan') {
      steps {
        // Inject secret token from Jenkins Credentials
        withCredentials([string(credentialsId: 'proxmox-token-secret', variable: 'PM_API_TOKEN_SECRET')]) {
          bat """
            set TF_VAR_pm_api_url=%PM_API_URL%
            set TF_VAR_pm_api_token_id=%PM_API_TOKEN_ID%
            set TF_VAR_pm_api_token_secret=%PM_API_TOKEN_SECRET%

            cd %WORKSPACE%
            terraform init -input=false
            terraform validate
            terraform plan -out=tfplan -input=false
            terraform show -no-color tfplan > plan.txt || true
          """
        }
      }
      post {
        success {
          archiveArtifacts artifacts: 'plan.txt', fingerprint: true
        }
      }
    }

    stage('Manual Approval') {
      steps {
        input message: 'Approve apply to Proxmox?', ok: 'Apply'
      }
    }

    stage('Terraform Apply') {
      steps {
        withCredentials([string(credentialsId: 'proxmox-token-secret', variable: 'PM_API_TOKEN_SECRET')]) {
          bat """
            set TF_VAR_pm_api_url=%PM_API_URL%
            set TF_VAR_pm_api_token_id=%PM_API_TOKEN_ID%
            set TF_VAR_pm_api_token_secret=%PM_API_TOKEN_SECRET%

            cd %WORKSPACE%
            terraform apply -input=false -auto-approve tfplan
          """
        }
      }
    }
  }

  post {
    always {
      bat 'cd %WORKSPACE% && terraform output || echo No outputs'
    }
  }
}
