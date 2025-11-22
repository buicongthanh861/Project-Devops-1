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
        KUBE_NAMESPACE = "congthanh"
    }   

    stages {
        stage('Clean Previous') {
            steps {
                sh """
                    docker stop my-app-test || true
                    docker rm my-app-test || true
                    docker rmi congthanh19/regapp:${env.BUILD_NUMBER} || true
                """
            }
        }
        
        stage('Clone') {
            steps {
                git branch: 'main', url: 'https://github.com/buicongthanh861/Project-Devops-1.git'
            }
        }

        stage('Build') {
            steps {
                echo '--------------- build started ------------'
                dir('webapp') {
                    sh 'mvn clean package -Dmaven.test.skip=true'
                }
            }
        }

        stage('Build docker image') {
            steps {
                echo '---------building docker---------'
                dir('webapp') {
                    sh "docker build --no-cache -t ${env.DOCKER_IMAGE} ."
                }
            }
        }

        stage('Test Deployment') {
            steps {
                sh """
                    docker run -d -p 8080:8080 --name my-app-test ${env.DOCKER_IMAGE}
                    sleep 30
                    curl -f http://localhost:8080/ || echo "Test failed"
                """
            }
        }

        stage('Login to DockerHub') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }

        stage('Push Docker Image') {
            steps {
                sh "docker push ${env.DOCKER_IMAGE}"
            }
        }

        stage('Kubernetes Deployment') {
            steps {
                withCredentials([usernamePassword(
                credentialsId: 'aws-cred', 
                usernameVariable: 'AWS_ACCESS_KEY_ID', 
                passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                )]) {
                sh """
                # Cấu hình AWS và EKS
                export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
                export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
                aws eks update-kubeconfig --name kubernets-cluster --region ap-southeast-1

                # Deploy
                kubectl create namespace congthanh 2>/dev/null || true
                kubectl apply -f regapp-deployment.yaml -n congthanh
                kubectl apply -f regapp-service.yaml -n congthanh
                kubectl rollout status deployment/regapp-deployment -n congthanh --timeout=300s
                kubectl get pods -n congthanh
                """
                }
            }
        }

    }

    post {
        always {
            sh """
                docker stop my-app-test || true
                docker rm my-app-test || true
            """
        }
    }
}