pipeline {
    agent {
            docker {
                args '-v /etc/passwd:/etc/passwd'
                image 'm4tt4r/server111'
            }
        }
    environment {
            ANSIBLE_PRIVATE_KEY=credentials('aws-private-key')
            AWS_DEFAULT_REGION='us-east-1'
            ANSIBLE_HOST_KEY_CHECKING=false
            ANSIBLE_TIMEOUT=600
        }
    stages {
        
        stage('Deploy Infrastructure') {
            steps {
                withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                 credentialsId: 'jenkins-awscli', 
                 screteKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                 )]){
                    
                    withEnv(["HOME=${env.WORKSPACE}"]) {
                    sh './create-stack.sh Jenkins-${BUILD_NUMBER} scripts/infrastructure.yml scripts/infra-parameters.json'
                    sh 'sleep 60'
                    sh './getEc2Ip.sh >> ansible/inventory.txt'
                    sh 'cat ansible/inventory.txt'
                }

                 }
            }   
        }
        stage('Configure Infrastructure') {
            steps {
                withEnv(["HOME=${env.WORKSPACE}"]) {
                    sh 'export ANSIBLE_HOST_KEY_CHECKING=False'
                    sh 'ansible-playbook ansible/playbook.yml -i ansible/inventory.txt --user ubuntu --private-key=$ANSIBLE_PRIVATE_KEY '
                }
                
            }  
        }
    }
    post {
        success {
            
            echo 'Hello from success'
        }
        unsuccessful {

            echo 'Hello from failure'
            
        }
    }
}