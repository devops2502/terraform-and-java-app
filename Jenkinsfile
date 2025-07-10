pipeline {
  agent { label 'AGENT-01' }
  when {
    allOf {
      branch 'main'
      changeset "**/src/**"
    }
  }
  stages {
    stage('Checkout Code') {
      steps {
        checkout scm
      }
    }
    stage('Build') {
      steps {
        sh './mvnw -B -DskipTests clean package'
      }
    }
    stage('Test') {
      steps {
        sh './mvnw test'
      }
      post {
        always {
          junit 'target/surefire-reports/*.xml'
        }
      }
    }
  }
}