pipeline {
  environment {
    registry = "rajxxx"
    registryCredential = 'dockerhub'
    dockerImage = ''
    PATH = "$PATH:/usr/local/bin"
  }
  agent any
  stages {
    stage('Cloning Git') {
      steps {
        git 'git@github.com:rajeever35/capstone.git'
        script {
        sh 'ls'
        }
      }
    }
    stage('HTML Lint') {
      steps {
        sh 'tidy -q -e html_file/index.html'
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker-compose build'
      }
    }

    stage('Push Images to Dockerhub') {
      steps{
        withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'DOCKER_P', usernameVariable: 'DOCKER_U')]) {
            sh "docker tag capstone:latest rajxxx/capstone:latest"
            sh "docker push rajxxx/capstone:latest"
          }
        }
      }

    stage('Docker Container') {
      steps {
        sh 'docker container run -d rajxxx/capstone:latest'
      }
    }
		stage('Set current kubectl context') {
			steps {
				withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'IAM', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
					sh '''
						kubectl config use-context arn:aws:eks:us-east-1:255514956001:cluster/my-cluster
					'''
				}
			}
		}
    stage('Deployment') {
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'IAM', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
          sh 'kubectl apply -f kubernetes_files/deploy.yml'
          sh 'kubectl apply -f kubernetes_files/LoadBalancer.yml'
        }
      }
    }

    stage('Rolling-out Deployment') {
      steps {
        sh 'kubectl rollout restart deployment/application'
      }
    }

  }
}