pipeline {
    agent any

    tools {
        maven 'Maven_3_8_4'
    }

    environment {
        JAVA_HOME = "/usr/lib/jvm/java-17-openjdk-amd64"
    }

    stages {

        stage('Clone') {
            steps {
                git url: 'https://github.com/buicongthanh861/Project-Devops-1.git'
            }
        }

        stage('Build') {
            steps {
                echo '--------------- build started------------'
                sh 'mvn clean package -Dmaven.test.skip=true'
            }
        }
    }
}