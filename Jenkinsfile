pipeline {
  agent { label 'AGENT-01' }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Validate PR rules') {
      when {
        changeRequest()
      }
      steps {
        script {
          if (env.CHANGE_BRANCH ==~ /^feature\/.*/ && env.CHANGE_TARGET == 'main') {
            error "Không được phép merge feature/* vào main"
          }
          if (env.CHANGE_BRANCH ==~ /^feature\/.*/ && env.CHANGE_TARGET == 'staging') {
            error "Không được phép merge feature/* vào staging"
          }
          if (env.CHANGE_BRANCH ==~ 'develop' && env.CHANGE_TARGET == 'main') {
            error "Không được phép merge develop vào main"
          }
        }
      }
    }

    stage('Build') {
      when {
        anyOf {
          anyOf {
            changeRequest()
            expression { return env.CHANGE_BRANCH ==~ /^feature\/.*/ || env.CHANGE_BRANCH ==~ /^hotfix\/.*/}
            anyOf {
              changeset "src/**"
              changeset "**/pom.xml"
            }
          }
          expression { return ['develop', 'staging', 'main'].contains(env.BRANCH_NAME)}
        }
      }
      steps {
        sh './mvnw -B -DskipTests clean package'
      }
    }

    stage('Test') {
      when {
        anyOf {
          allOf {
            changeRequest()
            expression { return env.CHANGE_BRANCH ==~ /^feature\/.*/ || env.CHANGE_BRANCH ==~ /^hotfix\/.*/}
            anyOf {
              changeset "src/**"
              changeset "**/pom.xml"
            }
          }
          expression { return ['develop', 'staging', 'main'].contains(env.BRANCH_NAME)}
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

    stage('Deploy') {
      when {
        anyOf {
          // not { changeRequest() }
          expression {
            return !changeRequest() && ['develop', 'staging', 'main'].contains(env.BRANCH_NAME)
          }
        }
      }
      steps {
        script {
          def selectedEnv = input(
            id: 'DeployEnv', message: 'Chọn môi trường để deploy:',
            parameters: [
              choice(name: 'ENV', choices: ['dev', 'staging', 'prod'], description: 'Chọn môi trường')
            ]
          )
          echo "Đang deploy lên môi trường: ${selectedEnv.toUpperCase()}"

          switch (selectedEnv) {
            case 'dev':
              if (env.BRANCH_NAME != 'develop') {
                error "Không thể deploy DEV từ nhánh ${env.BRANCH_NAME}. Phải là develop."
              }
              echo "Deploying to DEV"
              // sh './scripts/deploy-dev.sh'
              break

            case 'staging':
              if (env.BRANCH_NAME != 'staging') {
                error "Không thể deploy STAGING từ nhánh ${env.BRANCH_NAME}. Phải là staging."
              }
              echo "Deploying to STAGING"
              // sh './scripts/deploy-staging.sh'
              break

            case 'prod':
              if (env.BRANCH_NAME != 'main') {
                error "Không thể deploy PROD từ nhánh ${env.BRANCH_NAME}. Phải là main."
              }
              input message: "Xác nhận deploy lên PROD?"
              echo "Deploying to PROD"
              // sh './scripts/deploy-prod.sh'
              break

            default:
              echo "Không có môi trường phù hợp. Bỏ qua deploy."
          }
        }
      }
    }

  }
}