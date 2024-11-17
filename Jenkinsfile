pipeline {
    agent any

    stages {
        stage('Build') {
            agent {
                docker 
                { 
                image 'node:18-alpine'
                reuseNode true
               }
              }
              environment {
                // Set a writable cache directory within the workspace
                npm_config_cache = "${WORKSPACE}/.npm-cache"
            }
            steps {
                sh '''
                    ls -la
                    node --version
                    npm --version
                    npm ci
                    npm run build 
                    ls -la 
                '''
            }
        }

        stage('Test'){
            agent {
                docker 
                { 
                image 'node:18-alpine'
                reuseNode true
               }
              }
            steps{
                sh '''
                test -f build/index.html
                npm test
                ls -la
                '''
            }
            
        }
    }

    post {
        always{
            junit 'test-results/junit.xml'
        }
    }
}
