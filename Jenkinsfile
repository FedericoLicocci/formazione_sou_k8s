pipeline {
    agent any
    
    environment {
        DOCKER_HUB_NAME = 'fedelic'
        IMAGE_NAME = 'test'
	KUBECONFIG = credentials('kube-config-file')
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
                         IMAGE_TAG = "develop-${shacommit}"
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
                withCredentials([usernamePassword(credentialsId: 'docker-token',
                                                  passwordVariable: 'DOCKER_PASS',
                                                  usernameVariable: 'DOCKER_USER')]) {
                                                      sh "echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin"
                                                      sh "docker push ${DOCKER_HUB_NAME}/${IMAGE_NAME}:latest"
                                                      sh "docker logout"
                                                  }
            }
        }
	stage('Check helm') {
	    agent {
                docker {
                    image 'alpine/helm:latest'
		            args '-u root --network host --entrypoint=""'
                }
            }
            steps {
	        withCredentials([file(credentialsId: 'kube-config-file', variable: 'KUBECONFIG')]) {
                    sh "helm upgrade --install test ./charts --namespace formazione-sou --create-namespace --wait"
                }
	    }
	}
    }
}

