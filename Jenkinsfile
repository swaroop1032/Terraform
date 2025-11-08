// Jenkinsfile (Windows PowerShell) - corrected (no '||' usage)
pipeline {
  agent any

  environment {
    TF_IN_AUTOMATION = "1"
    PM_API_URL = "https://192.168.31.180:8006/api2/json"    // <-- replace
    PM_API_TOKEN_ID = "terraform@pam!tf-token"            // <-- replace if needed
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Prepare & Validate') {
      steps {
        withCredentials([string(credentialsId: 'proxmox-token-secret', variable: 'PM_API_TOKEN_SECRET')]) {
          powershell """
            Write-Host "Workspace: $env:WORKSPACE"
            Set-Location -Path $env:WORKSPACE

            # Set Terraform provider variables
            $env:TF_VAR_pm_api_url = '${env.PM_API_URL}'
            $env:TF_VAR_pm_api_token_id = '${env.PM_API_TOKEN_ID}'
            $env:TF_VAR_pm_api_token_secret = '${PM_API_TOKEN_SECRET}'

            terraform -version

            terraform init -input=false
            if ($LASTEXITCODE -ne 0) { Write-Error 'terraform init failed'; exit $LASTEXITCODE }

            terraform validate
            if ($LASTEXITCODE -ne 0) { Write-Error 'terraform validate failed'; exit $LASTEXITCODE }
          """
        }
      }
    }

    stage('Plan') {
      steps {
        withCredentials([string(credentialsId: 'proxmox-token-secret', variable: 'PM_API_TOKEN_SECRET')]) {
          powershell """
            Set-Location -Path $env:WORKSPACE
            $env:TF_VAR_pm_api_url = '${env.PM_API_URL}'
            $env:TF_VAR_pm_api_token_id = '${env.PM_API_TOKEN_ID}'
            $env:TF_VAR_pm_api_token_secret = '${PM_API_TOKEN_SECRET}'

            terraform plan -out=tfplan -input=false
            if ($LASTEXITCODE -ne 0) {
              Write-Error 'terraform plan failed — check the console for details'
              exit $LASTEXITCODE
            }

            if (Test-Path -Path ./tfplan) {
              terraform show -no-color tfplan | Out-File -FilePath plan.txt -Encoding utf8
            } else {
              'No tfplan produced' | Out-File -FilePath plan.txt -Encoding utf8
            }
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
        input message: 'Review plan.txt and approve apply to Proxmox', ok: 'Apply'
      }
    }

    stage('Apply') {
      steps {
        withCredentials([string(credentialsId: 'proxmox-token-secret', variable: 'PM_API_TOKEN_SECRET')]) {
          powershell """
            Set-Location -Path $env:WORKSPACE
            $env:TF_VAR_pm_api_url = '${env.PM_API_URL}'
            $env:TF_VAR_pm_api_token_id = '${env.PM_API_TOKEN_ID}'
            $env:TF_VAR_pm_api_token_secret = '${PM_API_TOKEN_SECRET}'

            terraform apply -input=false -auto-approve tfplan
            if ($LASTEXITCODE -ne 0) {
              Write-Error 'terraform apply failed'
              exit $LASTEXITCODE
            }
          """
        }
      }
    }
  }

  post {
    always {
      // Run terraform output safely and never fail the post step
      powershell """
        Set-Location -Path $env:WORKSPACE

        # Run terraform output; it may return non-zero if no outputs or not initialized.
        & terraform output
        $rc = $LASTEXITCODE

        if ($rc -ne 0) {
          Write-Output 'No outputs available or terraform not initialized'
        }

        # Ensure this powershell script exits 0 so post does not fail the build
        exit 0
      """
    }
    failure {
      echo "Build failed — check console log and plan.txt artifact for details."
    }
  }
}
