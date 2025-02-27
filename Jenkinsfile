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
            
            // Run OWASP Dependency-Check
            dependencyCheck additionalArguments: '''
                -o './dependency-check-reports' 
                -s './' 
                -f 'ALL'
                --prettyPrint
                --log dependency-check-reports/dependency-check.log
                --debug
            ''', odcInstallation: 'My-OWASP-Dependency-Check'
            
            // Debug: Verify that the report files were generated
            sh 'ls -la dependency-check-reports'
            sh 'cat dependency-check-reports/dependency-check.log || true'
        }

        // Publish OWASP Dependency-Check results
        dependencyCheckPublisher pattern: 'dependency-check-reports/dependency-check-report.xml'
    }
}


    }
}
