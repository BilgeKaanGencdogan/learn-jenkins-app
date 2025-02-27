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
        stage('Build') 
        {
            steps {
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
        stage('Test') 
        {
            steps {
                sh '''
                    source "$NVM_DIR/nvm.sh"
                    npm test
                '''
            }
            post {
                always {
                    junit 'test-results/junit.xml'
                    sh 'ls -la'
                }
            }
        }

        stage('OWASP Dependency-Check Vulnerabilities') {
    steps {
        script {
            echo "Running OWASP Dependency-Check..."
            
            
            sh '''
                dependency-check \
                -o './dependency-check' \
                -s './' \
                -f 'XML' \
                --prettyPrint
            '''

            
            echo "Setting permissions for dependency-check directory..."
            sh 'chmod -R 755 ./dependency-check'
            
            
            echo "Listing files in dependency-check directory:"
            sh 'ls -R ./dependency-check || true'

            
            echo "Checking for report existence:"
            sh 'ls -l ./dependency-check/dependency-check-report.xml || true'
        }

        
        dependencyCheckPublisher pattern: 'dependency-check/dependency-check-report.xml'
    }
}



    }
}
