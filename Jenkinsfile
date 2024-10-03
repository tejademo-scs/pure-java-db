pipeline {
    agent any
    environment {
        ECR_REGISTRY = "735731564843.dkr.ecr.us-west-1.amazonaws.com/helloworldapp"
        ECR_REGION = "us-west-1"
        DOCKER_IMAGE = "vproapp"
	SLACK_CHANNEL = "#jenkinsci_job"
    }
    stages {
	/* stage('Generate artifact')
   {
	  agent{
	    docker { image 'maven:3.8.1-adoptopenjdk-11'}
		}
		steps{
		  sh 'mvn clean install -Dskiptests'
        }
	} */
    stage('Build Docker image') {
        steps {
            sh "docker build -t $DOCKER_IMAGE . "
            }
        }
    stage('Login to ECR') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'awscredentials', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    sh "aws ecr get-login-password --region $ECR_REGION | docker login --username AWS --password-stdin $ECR_REGISTRY"
                }
            }
        }
    stage('Push Docker image to ECR') {
            steps {
                sh "docker tag $DOCKER_IMAGE:latest $ECR_REGISTRY/$DOCKER_IMAGE:latest"
                sh "docker push $ECR_REGISTRY/$DOCKER_IMAGE:latest"
            }
        }
    }

     post {
    always {
      slackSend(
        color: getColor(),
        message: getMessage(),
        channel: env.SLACK_CHANNEL,
        tokenCredentialId: 'slacklogin'
      )
    }
  }
}
def getColor() {
  if (currentBuild.result == 'SUCCESS') {
    return 'good'
  } else if (currentBuild.result == 'FAILURE') {
    return 'danger'
  } else {
    return 'warning'
  }
}

def getMessage() {
  def message = "*Build ${currentBuild.result}:* ${currentBuild.fullDisplayName}"
  if (env.BUILD_URL) {
    message += "\n${env.BUILD_URL}"
  }
  return message
}
