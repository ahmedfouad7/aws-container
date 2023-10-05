// pipeline{
//     agent any
//     stages{
//         stage("build"){
//             steps{
//                 echo'building the application...'
//             }
//         }

//         stage("test"){
//             steps{
//                 echo'testing the application...'
//             }
//         }

//         stage("deploy"){
//             steps{
//                 echo'deploying the application...'
//             }
//         }
 
//     }
// }




 
pipeline {
    // agent any
    agent {
        docker { image 'python:3.9' }
    }
    environment {
        // Define environment variables for Docker Hub credentials, image name, etc.
        // DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        IMAGE_NAME = 'my-python-app'
        IMAGE_TAG  =  2.0  // "${env.BUILD_NUMBER}"
    }
    tools{
        maven
        gradle
        docker
    }
    stages {
        // stage('Checkout') {
        //     steps {
        //         // Checkout the code from source control
        //         git 'https://github.com/my-repo/my-python-app.git'
        //     }
        // }
        // stage('Test') {
        //     steps {
        //         // Run unit tests with pytest
        //         sh 'python -m pytest'
        //     }
        // }
        stage('Build') {
            steps {
                // Build a Docker image from the Dockerfile
                sh "docker build -t ${env.IMAGE_NAME}:${env.IMAGE_TAG} ."
            }
        }
        // stage('Push') {
            // steps {
            //     // Login to Docker Hub
            //     // sh "docker login -u ${env.DOCKERHUB_CREDENTIALS_USR} -p ${env.DOCKERHUB_CREDENTIALS_PSW}"
            //     // Push the image to Docker Hub
            //     // sh "docker push ${env.IMAGE_NAME}:${env.IMAGE_TAG}"
            // }
        // }
        stage('Deploy') {
            steps {
                // Deploy the image to a target environment
                sh "docker run -d -p 80:80 ${env.IMAGE_NAME}:${env.IMAGE_TAG}"
            }
        }
    }
}