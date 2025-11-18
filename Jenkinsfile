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
                echo '--------------- build started------------'
                sh 'mvn clean package -Dmaven.test.skip=true'
                sh 'ls -la target/*.war'
            }
        }
        
        stage('Deploy to tomcat') {
            steps {
                echo '------------deploying tomcat server------'
                sshPublisher(
                    publishers: [
                        sshPublisherDesc(
                            configName: 'tomcat-server',  // Tên SSH server đã cấu hình
                            transfers: [
                                sshTransfer(
                                    sourceFiles: 'target/*.war',
                                    removePrefix: 'target',
                                    remoteDirectory: '',
                                    execCommand: 'echo "Deploy thành công!"'
                                )
                            ]
                        )
                    ]
                )
            }
        }
    }
}