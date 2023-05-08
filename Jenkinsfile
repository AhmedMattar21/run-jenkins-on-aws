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
                    sh './scripts/create-stack.sh Jenkins-${BUILD_NUMBER} IaC/controller.yml IaC/parameters.json'
                    sh 'sleep 60'
                    sh './scripts/getEc2Ip.sh >> ansible/inventory.txt'
                    sh 'cat ansible/inventory.txt'
                }

                 }
            }   
            post {    
                unsuccessful {

                    slackSend color: 'danger', message: '''ERROR: Faild Deploying Infrastructure ... \
                            \nWORKSAPCE: run-jenkins-on-aws
                            \nBUILD_NUMBER: ${BUILD_NUMBER}
                        '''
                    
                }
            }
        }
        stage('Configure Infrastructure') {
            steps {
                withEnv(["HOME=${env.WORKSPACE}"]) {
                    sh 'export ANSIBLE_HOST_KEY_CHECKING=False'
                    sh 'ansible-playbook ansible/playbookX.yml -i ansible/inventory.txt --user ubuntu --private-key=$ANSIBLE_PRIVATE_KEY '
                    sh 'ls'
                }
                
            }  
            post {    
                unsuccessful {

                    slackSend color: 'danger', message: '''echo "ERROR: Faild Configuring Infrastructure ... \
                            \nWORKSAPCE: run-jenkins-on-aws
                            \nBUILD_NUMBER: ${BUILD_NUMBER}
                        '''

                    withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        credentialsId: 'jenkins-awscli', 
                        screteKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    )]){
                    
                    withEnv(["HOME=${env.WORKSPACE}"]) {
                    sh './scripts/delete-stack.sh Jenkins-${BUILD_NUMBER}'
                    }

                 }
                    
                }
            }

        }
    }
    post {
        success {
            
            slackSend color: 'good', message: '''echo "SUCCESS: Our Jenkins Server is Up and Running ... \
                            \nWORKSAPCE: run-jenkins-on-aws
                            \nBUILD_NUMBER: "${BUILD_NUMBER}"
                        '''
            
        }
    }
}