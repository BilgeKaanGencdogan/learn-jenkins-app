pipeline {
    agent any

    environment {
        NETLIFY_SITE_ID = 'f64217ac-7042-4c89-a7c2-727934a56cab'
        NETLIFY_AUTH_TOKEN = credentials('token-netlify')
    }

    stages 
    {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

      stage('Install Dependencies') {
    steps {
        script {
            // Install Node.js 18.x on Rocky Linux
            sh '''
                # Enable EPEL repository
                dnf install -y epel-release

                # Install Node.js 18.x from NodeSource
                curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
                dnf install -y nodejs

                # Verify the installation
                node --version
                npm --version

                # Install Retire.js globally
                npm install -g retire

                # Verify Retire.js installation
                which retire
            '''
        }
    }
}

        stage('Retire.js Vulnerability Check') {
            steps {
                script {
                    // Run Retire.js to check for vulnerabilities
                    sh 'retire --path . || exit 1'
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    // Install project dependencies and build the project
                    sh '''
                        npm ci --unsafe-perm
                        npm run build
                    '''
                }
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
                    steps {
                        sh 'npm run test:ci'
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
            steps {
                script {
                    // Install Netlify CLI and deploy
                    sh '''

                        # Install netlify-cli locally
                        npm install netlify-cli -g

                        # Deploy using netlify-cli
                        node_modules/.bin/netlify --version
                        echo "Deploying to production. Site ID: $NETLIFY_SITE_ID"
                        node_modules/.bin/netlify status
                        node_modules/.bin/netlify deploy --dir=build --prod
                    '''
                }
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




