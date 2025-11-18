pipeline {
    agent any

    tools {
        git 'Git'
        maven 'Maven_3_8_7'
    }

    environment {
        TOMCAT_HOST = "47.128.65.255:8080"
        TOMCAT_CREDS = credentials('tomcat-deployer')
    }

    stages {

        stage('Clone') {
            steps {
                git branch: 'main', url: 'https://github.com/buicongthanh861/Project-Devops-1.git'
            }
        }

        stage('Build') {
            steps {
                echo '--------------- build started------------'
                sh 'mvn clean package -Dmaven.test.skip=true'
                sh 'ls -la target/*.war'
            }
        }
        stage('Deploy to tomcat') {
            steps {
                echo '------------deploying tomcat server------'
                script {
                    def warFile = findFiles(glob:'target/*.war').[0].name
                    echo "Deploying file: ${warFile}"

                    //copy file war vao thu muc webapps cua tomcat
                    sh """
                        sudo cp target/${warFile} /opt/tomcat/apache-tomcat-10.1.49/webapps/
                        echo "Copy file WAR thành công!"
                    """
                }
            }
        }
        
    }
}
