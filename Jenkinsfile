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
                       
                        if [ ! -d "$NVM_DIR" ]; then
                            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
                            source "$NVM_DIR/nvm.sh"
                        fi
                        
                        source "$NVM_DIR/nvm.sh"
                        nvm install $NODE_VERSION
                        nvm use $NODE_VERSION
                        node -v  
                    '''
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    
                    sh '''
                        source "$NVM_DIR/nvm.sh"
                        nvm use $NODE_VERSION
                        node --version  
                        whoami
                        
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
                    
                    sh '''
                        source "$NVM_DIR/nvm.sh"
                        nvm use $NODE_VERSION
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

        // stage('Install Retire.js') 
        // {
        //     steps {
        //         script {
                  
        //             sh '''
        //                 source "$NVM_DIR/nvm.sh"
        //                 nvm use $NODE_VERSION
        //                 npm install -g retire  
        //                 retire  
        //             '''
        //         }
        //     }
        // }
            stage('Install bearer cli') 
        {
            steps {
                script {
                  
                    sh '''
                        source "$NVM_DIR/nvm.sh"
                        nvm use $NODE_VERSION
                        curl -sfL https://raw.githubusercontent.com/Bearer/bearer/main/contrib/install.sh | sh
                        ./bin/bearer scan .
                    '''
                }
            }
        }
    }
}
