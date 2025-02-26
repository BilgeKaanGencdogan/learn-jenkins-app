pipeline {
    agent any
    environment {
        NVM_DIR = "$HOME/.nvm"
        NODE_VERSION = "18"
    }
    stages {
        stage('Setup Node.js') {
            steps {
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
        stage('Build') {
            steps {
                sh '''
                    node --version
                    whoami
                    npm run build
                    ls -la
                '''
            }
        }
    }
}
