pipeline {
    agent any

    stages {

        stage('Check') {
            steps {
                sh 'grep Hello index.html'
            }
        }

        stage('Build') {
            steps {
                sh 'docker build -t hello-app .'
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                docker stop hello-container || true
                docker rm hello-container || true
                docker run -d --name hello-container -p 8081:80 hello-app
                '''
            }
        }

        stage('Health check') {
            steps {
                sh '''
                echo "Waiting for service..."

                sleep 3
                CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8081)

                echo "HTTP code: $CODE"

                if [ "$CODE" -ne 200 ]; then
                    echo "Service is DOWN"
                    exit 1
                fi

                echo "Service is UP"
                '''
            }
        }
    }
}
