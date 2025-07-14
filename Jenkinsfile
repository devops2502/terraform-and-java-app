pipeline {
  agent { label 'AGENT-01' }

  when {
    allOf {
      changeRequest()
      expression { return env.CHANGE_BRANCH ==~ /^feature\/.*/ }
    }
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Validate PR rules') {
      steps {
        script {
          echo "Validating PR: ${env.CHANGE_BRANCH} → ${env.CHANGE_TARGET}"

          if (env.CHANGE_BRANCH ==~ /^feature\/.*/ && env.CHANGE_TARGET != 'develop') {
            error "Không được phép merge feature/* vào ${env.CHANGE_TARGET}"
          }
        }
      }
    }

    stage('Build') {
      when {
        anyOf {
          changeset "**/src/**"
          changeset "**/pom.xml"
        }
      }
      steps {
        sh './mvnw -B -DskipTests clean package'
      }
    }

    stage('Test') {
      when {
        anyOf {
          changeset "**/src/**"
          changeset "**/pom.xml"
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