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
                        nvm use $NODE_VERSION
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
                        nvm use $NODE_VERSION
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

        stage('Install Retire.js') {
            steps {
                script {
                    sh '''
                        source "$NVM_DIR/nvm.sh"
                        nvm use $NODE_VERSION
                        whoami
                        npm install retire
                        retire
                    '''
                }
            }
        }
    }
}
