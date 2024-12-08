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
                    mkdir -p ${npm_config_cache} ${WORKSPACE}/.npmrc
                    echo 'cache=${npm_config_cache}' > ${WORKSPACE}/.npmrc
                    export NPM_CONFIG_USERCONFIG=${WORKSPACE}/.npmrc

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
                    export NPM_CONFIG_USERCONFIG=${WORKSPACE}/.npmrc

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
                npm_config_cache = "${WORKSPACE}/.npm-cache"
            }
            steps {
                sh '''
                    mkdir -p ${npm_config_cache} ${WORKSPACE}/.npmrc
                    echo 'cache=${npm_config_cache}' > ${WORKSPACE}/.npmrc
                    export NPM_CONFIG_USERCONFIG=${WORKSPACE}/.npmrc

                    npx netlify-cli --version
                    echo "Deploying to production. Site ID: $NETLIFY_SITE_ID"
                    npx netlify deploy --site $NETLIFY_SITE_ID --prod
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
