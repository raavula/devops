#!/bin/bash

'''
# For AWS 
builders":
{
      "type": "docker",
      "commit": true,
      "ecr_login": true,
      "login_username": "AWS",
      "login_password": "{{user `aws_ecr_pwd`}}",
      "login_server": "https://*******.dkr.ecr.us-east-1.amazonaws.com",
      "image": "****.dkr.ecr.us-east-1.amazonaws.com/sbg_cloudinfra_docker_aws:baseDockerImage_1.0.0",
      "run_command": ["-d", "-i", "-t", "{{.Image}}", "/bin/ash"]
}

"post-processors": [
    [
      {
        "type": "docker-tag",
        "repository": "******.dkr.ecr.us-east-1.amazonaws.com/repo-name/docker-1",
        "tag": "{{user `buildTag`}}"
      },
      {
        "type": "docker-push",
        "ecr_login": true,
        "login_server": "https://*****.dkr.ecr.us-east-1.amazonaws.com",
        "login_username": "AWS",
        "login_password": "{{user `aws_ecr_pwd`}}"
      }
    ]
  ]

'''
export PATH=$PATH:/usr/local/bin/packer
echo "Provide docker hub login ...."
docker login
packer build example_docker.json
