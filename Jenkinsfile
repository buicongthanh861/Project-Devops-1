pipeline {
    agent any

    tools {
        git 'Git'
        maven 'Maven_3_8_7'
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
        
        stage('Deploy to tomcat') {
            steps {
                echo '------------ deploying tomcat server ------'

                sshagent(['tomcat-server']) {
                    sh '''
                        echo "Finding WAR file..."
                        WAR_FILE=$(ls target/*.war)

                        echo "Copying WAR to remote Tomcat server..."
                        scp -o StrictHostKeyChecking=no "$WAR_FILE" ubuntu@10.1.1.40:/opt/tomcat/apache-tomcat-10.1.49/webapps/

                        echo "Restarting Tomcat..."
                        ssh -o StrictHostKeyChecking=no ubuntu@10.1.1.40 "bash /opt/tomcat/apache-tomcat-10.1.49/bin/shutdown.sh || true"
                        ssh -o StrictHostKeyChecking=no ubuntu@10.1.1.40 "bash /opt/tomcat/apache-tomcat-10.1.49/bin/startup.sh"

                        echo "Deploy thành công!"
                    '''
                }
            }
        }
    }
}
