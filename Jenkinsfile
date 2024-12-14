pipeline {
    agent any

    environment {
        NETLIFY_SITE_ID = 'f64217ac-7042-4c89-a7c2-727934a56cab'
        NETLIFY_AUTH_TOKEN = credentials('token-netlify')
    }

    stages 
    {
        stage('Build') {
            agent {
                docker {
                    image 'node:18-alpine'
                    args '-u root'
                    reuseNode true
                }
                // dockerfile true
            }
            steps {
                sh '''
                    ls -la
                    node --version
                    npm --version
                    npm ci --unsafe-perm
                    npm run build
                    ls -la
                '''
            }
        }

        stage('OWASP Dependency-Check Vulnerabilities') {
            steps {
                dependencyCheck additionalArguments: ''' 
                    -o './'
                    -s './'
                    -f 'ALL' 
                    --prettyPrint''', odcInstallation: 'OWASP Dependency-Check Vulnerabilities'
                
                dependencyCheckPublisher pattern: 'dependency-check-report.xml'
            }
        }

        stage('Tests') {
            parallel {
                stage('Unit tests') {
                    agent {
                        docker {
                            image 'node:18-alpine'
                            reuseNode true
                        }
                    }

                    steps {
                        sh '''
                            #test -f build/index.html
                            npm run test:ci
                        '''
                    }

                    post {
                        always {
                            junit 'test-results/junit.xml'
                        }
                    }
                }
            }
        }

       stage('Deploy') {
    agent {
        docker {
            image 'node:18-alpine'
            args '--user 992:989' // Replace with actual UID:GID
            reuseNode true
        }
    }
    steps {
        sh '''
            # Create a writable npm cache directory
            mkdir -p .npm-cache
            chmod -R 777 .npm-cache

            # Install netlify-cli locally
            npm install --cache .npm-cache --unsafe-perm netlify-cli

            # Deploy using netlify-cli
            node_modules/.bin/netlify --version
            echo "Deploying to production. Site ID: $NETLIFY_SITE_ID"
            node_modules/.bin/netlify status
            node_modules/.bin/netlify deploy --dir=build --prod
        '''
    }
}

    }

    post {
        always {
            // Publish Playwright report
            publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Playwright HTML Report', reportTitles: '', useWrapperFileDirectly: true])
        }
    }
}
