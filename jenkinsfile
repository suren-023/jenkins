pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Deploy Nginx') {
            steps {
                sh 'docker compose up -d'
            }
        }

        stage('Health Check') {
            steps {
                sh 'docker ps | grep nginx'
            }
        }
    }

    post {
        success {
            echo '✅ Nginx container is up!'
        }
        failure {
            echo '❌ Deployment failed.'
            sh 'docker compose logs --tail=30'
        }
    }
}
```

**Make sure your repo has:**
```
jenkins/
├── Jenkinsfile
└── docker-compose.yml
