pipeline {
    agent any
    
    environment {
        DOCKER_HUB_NAME = 'fedelic'
        IMAGE_NAME = 'test'
        IMAGE_TAG = 'latest'
    }
    stages{
        stage('Adding tag to image'){
            steps {
                script {
                    if (env.BRANCH_NAME == 'main') {
                         echo "Building from main branch"
                         IMAGE_TAG = "latest"
                    }
                    else if (env.BRANCH_NAME == 'develop') {
                         echo "Building from develop branch"
                         def shacommit = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()       
                         IMAGE_TAG = "develop-${sha-commit}"
                    }
                }
            }
        }
        stage('Build'){
            steps {
                script {
                    def docker_hub_name = env.DOCKER_HUB_NAME.toLowerCase()
                    def image_name = env.IMAGE_NAME.toLowerCase()
                    def image_tag = env.IMAGE_TAG.toLowerCase()
                    def fullname = "${docker_hub_name}/${image_name}"
                    sh "docker build -t ${fullname}:${image_tag} ."
                }
                
            }
        }
        stage('Push to Dockerhub') {
            steps {
                withCredentials([usernamePassword(credentialsId: '3cb32598-7703-44cf-83ac-5524142fb3b7',
                                                  passwordVariable: 'DOCKER_PASS',
                                                  usernameVariable: 'DOCKER_USER')]) {
                                                      sh "echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin"
                                                      sh "docker push ${DOCKER_HUB_NAME}/${IMAGE_NAME}:latest"
                                                      sh "docker logout"
                                                  }
            }
        }
    }
}
