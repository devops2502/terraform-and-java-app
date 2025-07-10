pipeline {
  agent { label 'AGENT-01' }

  stages {
    stage('Checkout Code') {
      steps {
        checkout scm
      }
    }

    stage('Build') {
      when {
        allOf {
          changeset "**/src/**"
        }
      }
      steps {
        sh './mvnw -B -DskipTests clean package'
      }
    }

    stage('Test') {
      when {
        allOf {
          changeset "**/src/**"
        }
      }
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
