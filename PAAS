
def COLOR_MAP= [
  'SUCCESS': 'good',
  'FAILURE': 'danger'
]
pipeline{
  agent any
  tools{
    maven "maven"
    jdk "openjdk8"
  }
  stages{
    stage('Fetch the code'){
      steps{
        git branch: 'master' , url: 'https://github.com/Teja-Chittamuri/HelloWolrd-DevopsE2E.git'
      }
    }
    stage('Build code')
    {
      steps{
        sh 'mvn clean install -Dskiptests'
      }
    }
    stage('Test')
    {
      steps{
        sh 'mvn test'
      }
    }
    stage(' CHECKSTYLE code analysis'){
      steps{
        sh 'mvn checkstyle:checkstyle'
      }
      post{
        success{
          echo 'Generating est reports'
        }
      }
    } 
  }
    post{
      always{
             echo 'Slack Notifications.'
            slackSend channel: '#jenkinsci_job',
                color: COLOR_MAP[currentBuild.currentResult],
                message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER} \n More info at: ${env.BUILD_URL}"
      }
    }
}
