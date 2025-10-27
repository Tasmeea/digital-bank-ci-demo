pipeline {
  agent { label 'worker-ec2' } // Orchestrator runs lightly on EC2 agent
  options { timestamps(); skipDefaultCheckout(true) }

  parameters {
    string(name: 'GIT_REPO', defaultValue: 'https://github.com/<your-org>/digital-bank-ci-demo.git', description: 'Repo URL')
    string(name: 'GIT_BRANCH', defaultValue: 'main', description: 'Project source code branch')
    choice(name: 'BUILD_MODE', choices: ['debug','test','release','release-protected'], description: 'Build mode')
    credentials(name: 'MIDDLEWARE_CREDS', description: 'Middleware credentials (Username/Password)', defaultValue: 'mw-creds')
    choice(name: 'ENV', choices: ['UAT','SIT','PROD'], description: 'Target environment')
    choice(name: 'TARGET_CHANNEL', choices: ['Web','Android','iOS'], description: 'Target channel')
    string(name: 'APP_VERSION', defaultValue: '1.2.3', description: 'Target version of mobile app (semver)')
    string(name: 'ANDROID_VERSION_CODE', defaultValue: '123', description: 'Android Version Code')
    string(name: 'IOS_BUNDLE_VERSION', defaultValue: '123', description: 'iOS Bundle Version')
    choice(name: 'IOS_DIST_TYPE', choices: ['debug','adhoc','enterprise','appstore'], description: 'iOS distribution type')
    booleanParam(name: 'RUN_CUSTOM_HOOK', defaultValue: true, description: 'Run custom hook before build?')
  }

  stages {
    stage('Checkout') {
      steps {
        checkout([$class: 'GitSCM',
          userRemoteConfigs: [[url: params.GIT_REPO]],
          branches: [[name: params.GIT_BRANCH]]
        ])
      }
    }

    stage('Custom Hook') {
      steps {
        sh "chmod +x ci/scripts/run_custom_hook.sh && ci/scripts/run_custom_hook.sh ${params.RUN_CUSTOM_HOOK}"
      }
    }

    stage('Route to Platform Build') {
      steps {
        script {
          if (params.TARGET_CHANNEL == 'Web') {
            build job: 'DBANK-Web-Build', parameters: [
              string(name: 'GIT_REPO', value: params.GIT_REPO),
              string(name: 'GIT_BRANCH', value: params.GIT_BRANCH),
              string(name: 'BUILD_MODE', value: params.BUILD_MODE),
              string(name: 'ENV', value: params.ENV),
              booleanParam(name: 'RUN_CUSTOM_HOOK', value: params.RUN_CUSTOM_HOOK),
              credentials(name: 'MIDDLEWARE_CREDS', value: params.MIDDLEWARE_CREDS)
            ], wait: true
          } else if (params.TARGET_CHANNEL == 'Android') {
            build job: 'DBANK-Android-Build', parameters: [
              string(name: 'GIT_REPO', value: params.GIT_REPO),
              string(name: 'GIT_BRANCH', value: params.GIT_BRANCH),
              string(name: 'BUILD_MODE', value: params.BUILD_MODE),
              string(name: 'ENV', value: params.ENV),
              string(name: 'APP_VERSION', value: params.APP_VERSION),
              string(name: 'ANDROID_VERSION_CODE', value: params.ANDROID_VERSION_CODE),
              booleanParam(name: 'RUN_CUSTOM_HOOK', value: params.RUN_CUSTOM_HOOK),
              credentials(name: 'MIDDLEWARE_CREDS', value: params.MIDDLEWARE_CREDS)
            ], wait: true
          } else {
            // iOS needs a Mac agent; this stub ensures the pipeline is teachable
            build job: 'DBANK-iOS-Build', parameters: [
              string(name: 'GIT_REPO', value: params.GIT_REPO),
              string(name: 'GIT_BRANCH', value: params.GIT_BRANCH),
              string(name: 'BUILD_MODE', value: params.BUILD_MODE),
              string(name: 'ENV', value: params.ENV),
              string(name: 'APP_VERSION', value: params.APP_VERSION),
              string(name: 'IOS_BUNDLE_VERSION', value: params.IOS_BUNDLE_VERSION),
              string(name: 'IOS_DIST_TYPE', value: params.IOS_DIST_TYPE),
              booleanParam(name: 'RUN_CUSTOM_HOOK', value: params.RUN_CUSTOM_HOOK),
              credentials(name: 'MIDDLEWARE_CREDS', value: params.MIDDLEWARE_CREDS)
            ], wait: true
          }
        }
      }
    }

    stage('Deploy') {
      steps {
        build job: 'DBANK-Deploy', parameters: [
          string(name: 'GIT_REPO', value: params.GIT_REPO),
          string(name: 'GIT_BRANCH', value: params.GIT_BRANCH),
          string(name: 'ENV', value: params.ENV),
          string(name: 'TARGET_CHANNEL', value: params.TARGET_CHANNEL),
          credentials(name: 'MIDDLEWARE_CREDS', value: params.MIDDLEWARE_CREDS)
        ], wait: true
      }
    }
  }
}
