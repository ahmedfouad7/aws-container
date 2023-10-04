## Create and Push Image on ECR

    ```
        docker build -t aws-continer-demo:2.0 .
        docker tag   aws-continer-demo:2.0 834545770024.dkr.ecr.us-east-1.amazonaws.com/aws-continer-demo
        docker push  834545770024.dkr.ecr.us-east-1.amazonaws.com/aws-continer-demo
    ```



## TO Run Container:
        docker run -p9090:9090 aws-continer-demo:2.0







docker run -d --restart=always -p 127.0.0.1:5555:5555 --network jenkins -v /var/run/docker.sock:/var/run/docker.sock python tcp-listen:5555,fork,reuseaddr unix-connect:/var/run/docker.sock
docker inspect <container_id> | grep IPAddress


________________________________________________________________________




Jenkins Commends:

docker run -p 8080:8080 -p 5000 5000 -d -v jenkins_home:/var/jenkins_home   jenkins/jenkins