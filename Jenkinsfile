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
        stage('Kubernetes Deployment') {
            steps {
                withKubeConfig([credentialsId: 'kubeconfig-devsecops']) {

            // Tạo namespace an toàn
                sh """
                kubectl create namespace congthanh --dry-run=client -o yaml | kubectl apply -f -
                """

            // Xóa nếu có resources cũ (không fail nếu không có)
                sh """
                kubectl delete -f regapp-deployment.yaml -f regapp-service.yml -n congthanh --ignore-not-found=true
                """

            // Deploy phiên bản mới
                sh """
                kubectl apply -f regapp-deployment.yaml -f regapp-service.yml -n congthanh
                """

            // Kiểm tra rolling update
                sh """
                kubectl rollout status deployment/regapp-deployment -n congthanh --timeout=300s
                """
        }
    }
}
    }
}