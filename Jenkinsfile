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
                    # Remove any pre-existing .npmrc directory to avoid conflicts
                    [ -d ${WORKSPACE}/.npmrc ] && rm -rf ${WORKSPACE}/.npmrc
                    
                    # Create cache directory and .npmrc file
                    mkdir -p ${npm_config_cache}
                    echo 'cache=${npm_config_cache}' > ${WORKSPACE}/.npmrc
                    export NPM_CONFIG_USERCONFIG=${WORKSPACE}/.npmrc

                    # Check setup
                    ls -la ${WORKSPACE}
                    ls -la ${npm_config_cache}
                    
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
                    export NPM_CONFIG_USERCONFIG=${WORKSPACE}/.npmrc

                    # Run tests
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
                    # Ensure cache and .npmrc
                    [ -d ${WORKSPACE}/.npmrc ] && rm -rf ${WORKSPACE}/.npmrc
                    mkdir -p ${npm_config_cache}
                    echo 'cache=${npm_config_cache}' > ${WORKSPACE}/.npmrc
                    export NPM_CONFIG_USERCONFIG=${WORKSPACE}/.npmrc

                    # Deploy with Netlify CLI
                    npm install -g netlify-cli
                    netlify --version
                    netlify deploy --site $NETLIFY_SITE_ID --prod
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
