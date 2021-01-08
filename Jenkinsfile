pipeline {
  environment {
    registry = "rajxxx"
    registryCredential = 'dockerhub'
    dockerImage = ''
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
    /*stage('HTML Lint') {
      steps {
        sh 'tidy -q -e html_file/index.html'
      }
    }*/

    stage('Build Docker Image') {
      steps {
        sh '/usr/local/bin/docker-compose build'
      }
    }

    stage('Push Images to Dockerhub') {
      steps{
        script {
          docker.withRegistry( '', registryCredential ) {
            sh "docker tag capstone:latest rajxxx/capstone:latest"
            sh "docker push rajxxx/capstone:latest"
            }
          }
        }
      }

    stage('Docker Container') {
      steps {
        sh 'docker container run -d rajxxx/capstone:latest'
      }
    }

    stage('Deployment') {
      steps {
        sh 'kubectl apply -f kubernetes_files/deploy.yml'
        sh 'kubectl apply -f kubernetes_files/LoadBalancer.yml'
      }
    }

    stage('Rolling-out Deployment') {
      steps {
        sh 'kubectl rollout restart deployment/application'
      }
    }

  }
}