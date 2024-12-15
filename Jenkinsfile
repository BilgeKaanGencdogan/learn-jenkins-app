pipeline {
    agent any

    environment {
        NETLIFY_SITE_ID = 'f64217ac-7042-4c89-a7c2-727934a56cab'
        NETLIFY_AUTH_TOKEN = credentials('token-netlify')
    }

    stages {
        stage('Build') {
            agent {
                docker {
                    image 'node:18-alpine'
                    args '--user root'
                    reuseNode true
                }
            }
            steps {
                sh '''
                    whoami
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
                            args '--user root'
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
                    args '--user root'
                    reuseNode true
                }
            }
            steps {
                sh '''
                     # Install netlify-cli locally in the project
                    npm install netlify-cli --unsafe-perm

                    # Verify installation
                    node_modules/.bin/netlify --version

                    # Deploy using netlify-cli
                    echo "Deploying to production. Site ID: $NETLIFY_SITE_ID"
                    node_modules/.bin/netlify status
                    node_modules/.bin/netlify deploy --dir=build --prod
                    '''

            }
        }
    }

   post {
    always {
        script {
            // Ensure the directory exists and has proper permissions
            sh '''
                if [ -d "playwright-report" ]; then
                    echo "Playwright report directory exists."
                else
                    echo "Playwright report directory does not exist. Creating it."
                    mkdir -p playwright-report
                fi

                # Ensure the directory has the right permissions
                chmod -R 755 playwright-report
            '''
        }

        // Publish Playwright report
        publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Playwright HTML Report', reportTitles: '', useWrapperFileDirectly: true])
    }
}

}
