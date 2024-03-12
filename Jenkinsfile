pipeline {
    agent any
    
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = 'us-east-1'
    }
    
    stages {
        stage('Terraform Plan & Validate') {
            when {
                branch 'terra'
            }
            steps {
                sh 'terraform init'
                sh 'terraform plan -out=tfplan'
                sh 'terraform validate'
            }
        }
        
        stage('Terraform Apply') {
            when {
                branch 'main'
            }
            steps {
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
    }
}
#comment