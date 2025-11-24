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

        stage('sonarqube analysis') {
            steps {
                withCredentials([string(credentialsId:'sonarqube', variable:'SONAR_TOKEN')]) {
                dir('webapp') {
                sh '''
                mvn clean verify sonar:sonar \
                -Dsonar.projectKey=buicongthanh861_Project-Devops-1 \
                -Dsonar.organization=java-woof \
                -Dsonar.host.url=https://sonarcloud.io \
                -Dsonar.token=${SONAR_TOKEN}
                '''
                }
                }
            }
        }

        stage('Run SCA Analysis Using Snyk') {
            steps {
                withCredentials([string(credentialsId: 'synk', variable: 'SNYK_TOKEN')]) {
                sh '''
                mvn snyk:test -Dsnyk.token=${SNYK_TOKEN} -fn
                '''
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
                withCredentials([aws(
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY',
                credentialsId: 'aws-cred'
            )]) {
                sh """
                aws eks update-kubeconfig --name kubernets-cluster --region ap-southeast-1
                
                # CÀI envsubst NẾU CHƯA CÓ
                which envsubst || (apt-get update && apt-get install -y gettext-base)
                
                # THAY THẾ BIẾN VÀ APPLY
                export BUILD_NUMBER=${env.BUILD_NUMBER}
                envsubst < regapp-deployment.yaml | kubectl apply -n ${env.KUBE_NAMESPACE} -f -
                kubectl apply -f regapp-service.yaml -n ${env.KUBE_NAMESPACE}
                
                kubectl rollout status deployment/regapp-deployment -n ${env.KUBE_NAMESPACE} --timeout=300s
                
                echo "Deployment thành công!"
                kubectl get pods,svc -n ${env.KUBE_NAMESPACE}
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