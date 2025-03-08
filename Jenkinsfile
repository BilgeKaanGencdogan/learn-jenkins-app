pipeline 
{
    agent any
    environment {
        NVM_DIR = "$HOME/.nvm"
        NODE_VERSION = "22"
    }
    stages 
    {
        stage('Setup Node.js') {
            steps {
                script {
                    sh '''
                        if [ ! -d "$NVM_DIR" ]; then
                            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
                            source "$NVM_DIR/nvm.sh"
                        fi
                        source "$NVM_DIR/nvm.sh"
                        nvm install $NODE_VERSION
                        nvm use $NODE_VERSION
                        node -v  # Verify node version
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
                   
                    junit 'test-results/junit.xml'
                    sh 'ls -la'
                }
            }
        }
        stage('Install Retire.js') 
        {
            steps {
                script {
                    sh '''
                    npm install -g retire
                    retire
                    '''
                }
            }
        }
        
    }
}
