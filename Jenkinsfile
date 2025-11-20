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
        DOCKER_IMAGE_LATEST = "congthanh19/regapp:latest"
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
                sh 'echo "WAR file:" && ls -la webapp/target/*.war'  
            }
        }
        
        // stage('Deploy to tomcat') {
        //     steps {
        //         deploy adapters: [tomcat9(
        //             credentialsId: 'tomcat-cred', 
        //             url: 'http://54.169.1.81:8080/'
        //         )], 
        //         war: 'webapp/target/*.war',  
        //         contextPath: null
        //     }
        // }

        stage('Build docker image') {
            steps {
                echo '---------building docker---------'
                sh """
                    docker build -t ${env.DOCKER_IMAGE} .
                    docker tag ${env.DOCKER_IMAGE} ${env.DOCKER_IMAGE_LATEST}
                """
                sh "docker images | grep congthanh19 "
            }
        }
        stage('login to dockerhub') {
            steps{
                echo '--------------- Logging to DockerHub ------------'
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }
        stage('Push Docker Image'){
            steps {
                echo "-------------------Pushing to DockerHub ---------------------"
                sh """
                    docker push ${env.DOCKER_IMAGE}
                    docker push ${env.DOCKER_IMAGE_LATEST}
                """
            }
        }
    }

    post {
        always{
            echo ' ----------------Cleanup------------'
            sh 'docker system prune -f || true'
        }
        success {
            echo "✅ Docker image pushed successfully!"
            sh """
                echo "Docker Image: ${env.DOCKER_IMAGE}"
                echo "Docker Image Latest: ${env.DOCKER_IMAGE_LATEST}"
                echo "K8s can now pull this image for deployment"
            """
        }
    }
}