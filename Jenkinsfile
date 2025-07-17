pipeline {
  agent { label 'AGENT-01' }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Validate PR Rules') {
      when {
        changeRequest()
      }
      steps {
        script {
          echo "Validating PR: ${env.CHANGE_BRANCH} → ${env.CHANGE_TARGET}"

          if (env.CHANGE_BRANCH ==~ /^feature\/.*/ && env.CHANGE_TARGET != 'develop') {
            error "Không được phép merge feature/* vào ${env.CHANGE_TARGET}"
          }

          if (env.CHANGE_BRANCH == 'develop' && env.CHANGE_TARGET != 'staging') {
            error "Không được phép merge develop vào ${env.CHANGE_TARGET}"
          }

          if (env.CHANGE_BRANCH == 'staging' && env.CHANGE_TARGET != 'main') {
            error "Không được phép merge staging vào ${env.CHANGE_TARGET}"
          }
        }
      }
    }

    stage('Build') {
      when {
        anyOf {
          // Build khi push trực tiếp lên feature/* hoặc merge vào develop, staging, main
          allOf {
            not { changeRequest() }
            expression { env.BRANCH_NAME ==~ /^feature\/.*/ || ['develop', 'staging', 'main', /^feature\/.*/].contains(env.BRANCH_NAME) }
            anyOf {
              changeset "src/**"
              changeset "**/pom.xml"
            } 
          }
          // Build lần đầu PR hoặc có thay đổi src/**, pom.xml
          allOf {
            changeRequest()
            expression {
              (env.CHANGE_BRANCH ==~ /^feature\/.*/ && env.CHANGE_TARGET == 'develop') ||
              (env.CHANGE_BRANCH == 'develop' && env.CHANGE_TARGET == 'staging') ||
              (env.CHANGE_BRANCH == 'staging' && env.CHANGE_TARGET == 'main')
            }
            anyOf {
              // Cho push lên lại vào PR
              changeset "src/**"
              changeset "**/pom.xml"
              // Cho tạo PR lần đầu
              allOf {
                not {
                  anyOf {
                    changeset "src/**"
                    changeset "**/pom.xml"
                  }
                }
                expression { currentBuild.changeSets.size() == 0 }
              }
            }
          }
        }
      }
      steps {
        sh './mvnw -B -DskipTests clean package'
      }
    }

    stage('Test') {
      when {
        anyOf {
          // Build khi push trực tiếp lên feature/* hoặc merge vào develop, staging, main
          allOf {
            not { changeRequest() }
            expression { env.BRANCH_NAME ==~ /^feature\/.*/ || ['develop', 'staging', 'main', /^feature\/.*/].contains(env.BRANCH_NAME) }
            anyOf {
              changeset "src/**"
              changeset "**/pom.xml"
            } 
          }
          // Build lần đầu PR hoặc có thay đổi src/**, pom.xml
          allOf {
            changeRequest()
            expression {
              (env.CHANGE_BRANCH ==~ /^feature\/.*/ && env.CHANGE_TARGET == 'develop') ||
              (env.CHANGE_BRANCH == 'develop' && env.CHANGE_TARGET == 'staging') ||
              (env.CHANGE_BRANCH == 'staging' && env.CHANGE_TARGET == 'main')
            }
            anyOf {
              // Cho push lên lại vào PR
              changeset "src/**"
              changeset "**/pom.xml"
              // Cho tạo PR lần đầu
              allOf {
                not {
                  anyOf {
                    changeset "src/**"
                    changeset "**/pom.xml"
                  }
                }
                expression { currentBuild.changeSets.size() == 0 }
              }
            }
          }
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
        allOf {
          not { changeRequest() }
          expression {
            return ['develop', 'staging', 'main'].contains(env.BRANCH_NAME)
          }
        }
      }
      steps {
        script {
          // def selectedEnv = input(
          //   id: 'DeployEnv', message: 'Chọn môi trường để deploy:',
          //   parameters: [
          //     choice(name: 'ENV', choices: ['dev', 'staging', 'prod'], description: 'Chọn môi trường')
          //   ]
          // )
          // echo "Đang deploy lên môi trường: ${selectedEnv.toUpperCase()}"

          switch (env.BRANCH_NAME) {
            case 'develop':
              echo "Deploying to DEV"
              // sh './scripts/deploy-dev.sh'
              break

            case 'staging':
              echo "Deploying to STAGING"
              // sh './scripts/deploy-staging.sh'
              break

            case 'main':
              timeout(time: 1, unit: 'HOURS') {
                input message: "Xác nhận deploy lên PROD?"
                echo "Deploying to PROD"
                // sh './scripts/deploy-prod.sh'
              }
              break

            default:
              echo "Không có môi trường phù hợp. Bỏ qua deploy."
          }
        }
      }
    }
  }
}

// changeset trong Jenkins chỉ gồm những thay đổi từ lúc PR mở trở đi
// changeset chỉ có tác dụng bên trong 1 stage ko có tác dụng kiểm soát trigger pipeline