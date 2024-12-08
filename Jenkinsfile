pipeline {
    agent any

    environment {
        NETLIFY_SITE_ID = 'f64217ac-7042-4c89-a7c2-727934a56cab'
    }

    stages {
        stage('Build') {
            agent {
                docker { 
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            environment {
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

        stage('Test') {
            agent {
                docker { 
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            steps {
                sh '''
                    test -f build/index.html
                    npm test
                    ls -la
                '''
            }
        }

      stage('Deploy') {
    agent {
        docker {
            image 'node:18-alpine'
            reuseNode true
        }
    }
    environment {
        npm_config_cache = "${WORKSPACE}/.npm-cache" // Ensures npm uses a writable cache
    }
    steps {
        sh '''
            mkdir -p ${npm_config_cache}
            npm install netlify-cli
            node_modules/.bin/netlify --version
            echo "Deploying to production. Site ID: $NETLIFY_SITE_ID"
        '''
    }
}

    }

    post {
        always {
            junit 'test-results/junit.xml'
        }
    }
}
