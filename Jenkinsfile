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
                bat 'mvn clean install'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withCredentials([string(credentialsId: 'sonar-token', variable: 'sonar-token')]) {
                    withSonarQubeEnv("${SONARQUBE_SERVER}") {
                        bat "mvn clean verify sonar:sonar -Dsonar.token=%sonar-token%"
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