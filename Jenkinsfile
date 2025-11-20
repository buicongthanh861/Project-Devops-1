pipeline {
    agent {
        node {
            label 'maven'
        }
    }

    environment {
        PATH = "/opt/apache-maven-3.9.9/bin:$PATH"
        DOCKERHUB_CREDENTIALS = credentials('DockerHub-cred')
        DOCKER_IMAGE = "congthanh19/regapp:${env.BUILD_NUMBER}"
    }   

    stages {
        stage('Clone') {
            steps {
                git branch: 'main', url: 'https://github.com/buicongthanh861/Project-Devops-1.git'
            }
        }

        stage('Build') {
            steps {
                echo '--------------- build started ------------'
                sh 'mvn clean package -Dmaven.test.skip=true'
            }
        }

        stage('Build docker image') {
            steps {
                echo '---------building docker---------'
                // Build Docker image
                sh "docker build -t ${env.DOCKER_IMAGE} ."
            }
        }

        stage('login to dockerhub') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }

        stage('Push Docker Image') {
            steps {
                sh "docker push ${env.DOCKER_IMAGE}"
            }
        }
    }

    post {
        always {
            echo '--------------- Cleanup ------------'
            sh 'docker system prune -f || true'
        }
    }
}