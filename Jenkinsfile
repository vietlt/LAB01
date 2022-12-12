pipeline {
    
    tools {
        terraform 'terraform'
        
    }
    
    agent {
        label params.AGENT == "any" ? "" : params.AGENT 
    }

    parameters {
        choice(name: "AGENT", choices: ["any", "docker", "windows", "linux"]) 
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-secret-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    }

    stages {
        stage("Ansible"){
            steps {
                sh '''
                    sudo apt-get install -y python3-pip

                    sudo pip3 install --upgrade pip

                    sudo python3 -V

                    sudo pip --version

                    sudo pip3 install pywinrm && \

                    sudo pip3 install ansible
                    
                    sudo chmod 400 terraform-key-pair.pem
                '''
            }
        }
        stage("Build") {
            steps {
                sh '''
                    docker build -t vietlt215/angular-app .
                '''
            }
        }

        stage('Init Provider') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Plan Resources') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }
        stage('Apply Resources') {
            input {
                message "Do you want to proceed for production deployment?"
            }
            steps {
                sh 'terraform apply "tfplan"'
            }
        }
    }
}
