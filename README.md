# Cloud DevOps Engineer Capstone Project

> Capstone project of the Udacity DevOps Engineer Nanodegree

## Project Tasks:

* Working in AWS
* Using Jenkins to implement Continuous Integration and Continuous Deployment
* Building pipelines
* Working with CloudFormation to deploy clusters
* Building Kubernetes clusters
* Building Docker containers in pipelines

In this project I have applied the skills and knowledge which were developed throughout the Cloud DevOps Nanodegree program.

## Application
The application used here is a basic website with an index.html page that runs over the NGINX server. I have created a CI/CD pipeline that deploys website to a cluster in AWS EKS which is Rollout Deployment.

## Kubernetes Cluster

Cloudformation is used to deploy the Kubernetes Cluster and the NodeGroup. The code is in [cloudformation_files](clodformation_files) directory. It is divided in two stacks, one for the network (network.yml) and a second one for the cluster itself ([AWS_EKS.yml](cloudformation_files/AWS_EKS.yml)).


## Jenkins Pipeline

I am using a CI/CD pipeline on a rolling deployment. On each HTML change, the docker image is pushed to AWS and the Kubernetes pods are rolled out so they restart with the new image from the repository. There is a load balancer before the exposed 8000 TCP ports to avoid having downtime. These are the steps in more detail:

![Jenkins Pipeline](./jenkins pipeline)

1. Create network environment to the AWS 
> ./create.sh capstone-network network.yml network-parameters.json
2. Then create AWS ELK cluster 
> ./create.sh capstone-eks AWS_EKS.yml AWS_EKS_parameters.json
3. Create Image 
> docker-compose build
4. Tag & Push
> docker tag capstone:latest rajxxx/capstone:latest  

> docker push rajxxx/capstone:latest

5. Start Docker Container 
> docker container run -d rajxxx/capstone:latest

6. Set current kubectl context
> kubectl config use-context arn:aws:eks:us-east-1:418573230812:cluster/AWSEKSCLUSTER

7. Deployment
> kubectl apply -f kubernetes_files/deploy.yml
> kubectl apply -f kubernetes_files/LoadBalancer.yml

7. Rollout Deployment

Rollout the pods to use the new pushed image.
> kubectl rollout restart deployment/application

## View the public web page

Finally, enter the public DNS record in the web browser to access the page.

```
$ kubectl get deployment
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
application   1/1     1            1           67m
