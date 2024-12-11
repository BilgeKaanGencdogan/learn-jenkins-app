pipeline {
    agent any

    environment {
        NETLIFY_SITE_ID = 'f64217ac-7042-4c89-a7c2-727934a56cab'
        npm_config_cache = "${WORKSPACE}/.npm-cache"
        NPM_CONFIG_USERCONFIG = "${WORKSPACE}/.npmrc"
    }

    stages {
        stage('Build') {
            agent {
                docker { 
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            steps {
                sh '''
                    # Setup npm cache
                    mkdir -p ${npm_config_cache}
                    echo 'cache=${npm_config_cache}' > ${NPM_CONFIG_USERCONFIG}

                    # Install dependencies and build
                    node --version
                    npm --version
                    npm ci
                    npm run build
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
                    # Run tests
                    test -f build/index.html
                    npm test -- --detectOpenHandles
                '''
            }
        }

        stage('Deploy') {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                    args '--user 0'
                }
            }
            steps {
                sh '''
                    # Setup npm cache
                    mkdir -p ${npm_config_cache}
                    echo 'cache=${npm_config_cache}' > ${NPM_CONFIG_USERCONFIG}

                    # Install and use Netlify CLI
                    npm install netlify-cli
                    npx netlify deploy --site $NETLIFY_SITE_ID --prod
                '''
            }
        }
    }

    post {
        always {
            junit 'test-results/junit.xml'
            archiveArtifacts artifacts: 'build/**/*'
        }
    }
}
