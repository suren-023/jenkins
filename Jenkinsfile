pipeline {
    agent none  // Assign per stage

    triggers {
        githubPush()  // Auto-trigger on GitHub push
    }

    stages {

        stage('Checkout') {
            agent { label 'built-in' }  // Run on Jenkins master
            steps {
                checkout scm
                echo "✅ Code checked out"
            }
        }

        stage('Deploy to nginx-web') {
            agent { label 'built-in' }  // Master has Docker socket
            steps {
                sh '''
                    echo "📦 Copying files to nginx-web container..."
                    docker cp index.html  nginx-web:/usr/share/nginx/html/
                    docker cp style.css   nginx-web:/usr/share/nginx/html/
                    docker cp script.js   nginx-web:/usr/share/nginx/html/
                    echo "🔄 Reloading Nginx..."
                    docker exec nginx-web nginx -s reload
                    echo "✅ Deployment complete!"
                '''
            }
        }
    }

    post {
        success { echo '🎉 Pipeline SUCCESS — site is live at http://<your-host-ip>' }
        failure  { echo '❌ Pipeline FAILED — check logs above' }
    }
}
