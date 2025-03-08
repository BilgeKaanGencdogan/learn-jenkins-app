pipeline {
    agent any
    environment {
        NVM_DIR = "$HOME/.nvm"
        NODE_VERSION = "22"
    }
    stages {
        stage('Setup Node.js') {
            steps {
                script {
                    sh '''
                        # Check if NVM is installed, install it if not
                        if [ ! -d "$NVM_DIR" ]; then
                            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
                            source "$NVM_DIR/nvm.sh"
                        fi
                        # Ensure NVM is sourced and install Node.js
                        source "$NVM_DIR/nvm.sh"
                        nvm install $NODE_VERSION
                        nvm use $NODE_VERSION
                        node -v  # Verify the Node.js version
                    '''
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    // Use the correct Node.js version and install dependencies
                    sh '''
                        source "$NVM_DIR/nvm.sh"
                        nvm use $NODE_VERSION
                        node --version  # Verify Node.js version
                        whoami
                        # Ensure npm is installed
                        npm install
                        npm run build
                        ls -la  # List the files after build
                    '''
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    // Run tests after building
                    sh '''
                        source "$NVM_DIR/nvm.sh"
                        nvm use $NODE_VERSION
                        npm test
                    '''
                }
            }
            post {
                always {
                    junit 'test-results/junit.xml'  // Ensure test results are published
                    sh 'ls -la'  // List files after test execution
                }
            }
        }

        stage('Install Retire.js') {
            steps {
                script {
                    // Install and run Retire.js
                    sh '''
                        source "$NVM_DIR/nvm.sh"
                        nvm use $NODE_VERSION
                        npm install -g retire  # Install retire globally
                        retire  # Run retire
                    '''
                }
            }
        }
    }
}
