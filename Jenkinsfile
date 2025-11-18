pipeline {
    agent {
        node {
            label 'maven'
        }
    }

    environment {
        PATH = "/opt/apache-maven-3.9.9/bin:$PATH "
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
                sh 'echo "WAR file:" && ls -la target/*.war'
            }
        }
       
        
    }
}
