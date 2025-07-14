pipeline {
  agent { label 'AGENT-01' }

  when {
    allOf {
      changeRequest()
      expression { return env.CHANGE_BRANCH ==~ /^feature\/.*/ }
      anyOf {
        changeset "src/**"
        changeset "**/pom.xml"
      }
    }
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }
  }

  stage('Validate PR rules') {
    when {
      changeRequest()
    }
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