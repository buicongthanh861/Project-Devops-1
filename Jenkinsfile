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
                sh 'echo "WAR file:" && ls -la target/webapp.war'  
                
                // Copy với đúng tên app.war như Dockerfile mong đợi
                sh 'cp target/webapp.war ./app.war'
                sh 'ls -la app.war'
            }
        }

        stage('Build docker image') {
            steps {
                echo '---------building docker---------'
                
                // Kiểm tra các file cần thiết
                sh 'ls -la Dockerfile app.war tomcat-users.xml context.xml || echo "Some files missing"'
                
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