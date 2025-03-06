pipeline {
    agent any
    environment {
        NVM_DIR = "$HOME/.nvm"
        NODE_VERSION = "18"
    }
    stages {
        stage('Setup Node.js') {
            steps {
                script {
                    // Install NVM and Node.js
                    sh '''
                        if [ ! -d "$NVM_DIR" ]; then
                            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
                            source "$NVM_DIR/nvm.sh"
                        fi
                        source "$NVM_DIR/nvm.sh"
                        nvm install $NODE_VERSION
                        nvm use $NODE_VERSION
                    '''
                }
            }
        }
        
        stage('Build') {
            steps {
                script {
                    // Build with Node.js
                    sh '''
                        source "$NVM_DIR/nvm.sh"
                        node --version
                        whoami
                        sudo dnf install -y npm
                        npm install
                        npm run build
                        ls -la
                    '''
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    // Run tests
                    sh '''
                        source "$NVM_DIR/nvm.sh"
                        npm test
                    '''
                }
            }
            post {
                always {
                    // Collect JUnit results and print the directory listing
                    junit 'test-results/junit.xml'
                    sh 'ls -la'
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

        // stage('OWASP Dependency-Check Vulnerabilities') 
        // {
        //     steps {
        //         script {
        //             // Run OWASP Dependency-Check
        //             sh '''
        //                 # Ensure Dependency-Check tool is installed and available
        //                 echo "Running OWASP Dependency-Check..."

        //                 # Run Dependency-Check tool in the project directory
        //                 dependency-check \
        //                     -o './dependency-check' \
        //                     -s './' \
        //                     -f 'XML' \
        //                     --prettyPrint
                        
        //                 # Ensure the output directory is correct and accessible
        //                 ls -la ./dependency-check
        //             '''
        //         }
        //     }
        //     post {
        //         always {
        //             // Publish the Dependency-Check report (if it exists)
        //             dependencyCheckPublisher pattern: 'dependency-check/dependency-check-report.xml'

        //             // List the files in the dependency-check folder for debugging
        //             echo "Listing dependency-check directory:"
        //             sh 'ls -la ./dependency-check'
        //         }
        //     }
        // }
    }
}
