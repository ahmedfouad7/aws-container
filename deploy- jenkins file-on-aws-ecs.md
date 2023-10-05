## Deploy a python application  on aws ecs fargate using jenkins file.


pipeline {
    agent any
    environment {
        // Define environment variables for AWS credentials, region, ECR repository, etc.
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION = 'us-east-1'
        ECR_REPOSITORY = 'my-ecr-repository'
        ECR_IMAGE_TAG = "${env.BUILD_NUMBER}"
        CFN_STACK_NAME = 'my-cfn-stack'
        CFN_TEMPLATE_FILE = 'cfn-template.yaml'
        CFN_PARAMETERS_FILE = 'cfn-parameters.json'
    }
    stages {
        stage('Install dependencies and run tests') {
            steps {
                // Install pip and other dependencies
                sh 'sudo yum install -y python-pip'
                sh 'sudo pip install --upgrade pip'
                sh 'sudo pip install -r requirements.txt'
                // Run unit tests
                sh 'python -m unittest discover tests'
            }
        }
        stage('Build and push Docker image') {
            steps {
                // Login to ECR
                sh "aws ecr get-login-password --region ${env.AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${env.AWS_ACCOUNT_ID}.dkr.ecr.${env.AWS_DEFAULT_REGION}.amazonaws.com"
                // Build Docker image
                sh "docker build -t ${env.ECR_REPOSITORY}:${env.ECR_IMAGE_TAG} ."
                // Push Docker image to ECR
                sh "docker push ${env.ECR_REPOSITORY}:${env.ECR_IMAGE_TAG}"
            }
        }
        stage('Deploy to ECS Fargate') {
            steps {
                // Create or update CloudFormation stack
                sh "aws cloudformation deploy --stack-name ${env.CFN_STACK_NAME} --template-file ${env.CFN_TEMPLATE_FILE} --parameter-overrides file://${env.CFN_PARAMETERS_FILE} --capabilities CAPABILITY_IAM"
                // Wait for CloudFormation stack to complete
                sh "aws cloudformation wait stack-create-complete --stack-name ${env.CFN_STACK_NAME}"
                sh "aws cloudformation wait stack-update-complete --stack-name ${env.CFN_STACK_NAME}"
                // Get the ECS service name from the stack outputs
                script {
                    env.ECS_SERVICE_NAME = sh(script: "aws cloudformation describe-stacks --stack-name ${env.CFN_STACK_NAME} --query 'Stacks[0].Outputs[?OutputKey==\\`ECSServiceName\\`].OutputValue' --output text", returnStdout: true).trim()
                }
                // Wait for the ECS service to be stable
                sh "aws ecs wait services-stable --cluster ${env.CFN_STACK_NAME} --services ${env.ECS_SERVICE_NAME}"
            }
        }
        stage('Verify deployment') {
            steps {
                // Get the load balancer DNS name from the stack outputs
                script {
                    env.LB_DNS_NAME = sh(script: "aws cloudformation describe-stacks --stack-name ${env.CFN_STACK_NAME} --query 'Stacks[0].Outputs[?OutputKey==\\`LoadBalancerDNSName\\`].OutputValue' --output text", returnStdout: true).trim()
                }
                // Check the response from the load balancer endpoint
                sh "curl -s http://${env.LB_DNS_NAME}/ | grep 'Hello, World'"
            }
        }
    }
}
