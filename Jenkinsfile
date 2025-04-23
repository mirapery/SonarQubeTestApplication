pipeline {
    agent any

    environment {
        SONARQUBE_SERVER = 'SonarQubeServer'
        DOCKER_IMAGE = 'mirapery/SonarQubeTestApplication'
        DOCKER_TAG = 'latest'
    }

    stages {
        stage('Checkout') {
            steps {
                cleanWs ()
                git branch: 'main', url: 'https://github.com/mirapery/SonarQubeTestApplication.git'
            }
        }

        stage('Build') {
            steps {
                script {
                    def mvnHome = tool name: 'Maven', type: 'maven'
                    bat "${mvnHome}/bin/mvn clean install"
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withCredentials([string(credentialsId: 'sonarqube-token', variable: 'SONAR_TOKEN')]) {
                    withSonarQubeEnv("${SONARQUBE_SERVER}") {
                        bat "mvn clean verify sonar:sonar -Dsonar.login=%SONAR_TOKEN"
                    }
                }
            }
        }

        stage('Docker Build & Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-hub-creds',
                    usernamePassword: 'DOCKER_USERNAME',
                    passwordVariable: 'DOCKER_PASSWORD'
                )]) {
                    bat """
                        docker build -t %DOCKER_IMAGE%:%DOCKER_TAG% .
                        echo %DOCKER_PASSWORD% | docker login -u %DOCKER_USERNAME% --password-stdin
                        docker push %DOCKER_IMAGE%:%DOCKER_TAG%
                    """
                }
            }
        }
    }
}