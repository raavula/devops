# Packer Example


# To build AMI image
# packer validate example_ami.json
#  packer build example_ami.json



# To build docker imahe
# packer build example_docker.json



# SOME NOTES
1. Mainly 4 sections : variables, builders, provisioners , post-processors

2. Passing arguments to build command shows below
   packer build \
    -var 'aws_access_key=YOUR ACCESS KEY' \
    -var 'aws_secret_key=YOUR SECRET KEY' \
    example.json 
 
    In example.json 
    "access_key": "{{user `aws_access_key`}}",
    "secret_key": "{{user `aws_secret_key`}}",

3. builders: AWS EC2, ECS, AZURE, Docker etc
  https://www.packer.io/docs/builders/index.html


4. provisioners types: shell local-remote, ansible local-remote,File ,windows, chef etc  
   https://www.packer.io/docs/provisioners/index.html

   {
  "variables": ["..."],
  "builders": ["..."],

  "provisioners": [{
    "type": "shell",
    "inline": [
      "sleep 30",
      "sudo apt-get update",
      "sudo apt-get install -y redis-server"
    ]
  }]
}


5. post processor : Post-processors run after the image is built by the builder and provisioned by the provisioner(s).
                    Post-processors are optional, and they can be used to upload artifacts, re-package, or more
   Example: Amazon import, Cheksum, Docker push,save,tag , shell, vagrant etc
   
   {
  "post-processors": [
    [
      {
        "type": "docker-tag",
        "repository": "12345.dkr.ecr.us-east-1.amazonaws.com/packer",
        "tag": "0.7"
      },
      {
        "type": "docker-push",
        "ecr_login": true,
        "aws_access_key": "YOUR KEY HERE",
        "aws_secret_key": "YOUR SECRET KEY HERE",
        "login_server": "https://12345.dkr.ecr.us-east-1.amazonaws.com/"
      }
    ]
  ]
}


The -except option can specifically skip a named post processor. The -only option ignores post-processors.
[
  {
    // can be skipped when running `packer build -except vbox`
    "name": "vbox",
    "type": "vagrant",
    "only": ["virtualbox-iso"]
  },
  {
    "type": "compress" // will only be executed when vbox is
  }
],
[
  "compress", // will run even if vbox is skipped, from the same start as vbox.
  {
    "type": "upload",
    "endpoint": "http://example.com"
  }
  // this list of post processors will execute
  // using build, not another post-processor.
]



6. Supports Parallel builds
   {
  "variables": {
    "aws_access_key": "",
    "aws_secret_key": "",
    "do_api_token": ""
  },
  "builders": [{
    "type": "amazon-ebs",
    "access_key": "{{user `aws_access_key`}}",
    "secret_key": "{{user `aws_secret_key`}}",
    "region": "us-east-1",
    "source_ami": "ami-fce3c696",
    "instance_type": "t2.micro",
    "ssh_username": "ubuntu",
    "ami_name": "packer-example {{timestamp}}"
  },{
    "type": "digitalocean",
    "api_token": "{{user `do_api_token`}}",
    "image": "ubuntu-14-04-x64",
    "region": "nyc3",
    "size": "512mb",
    "ssh_username": "root"
  }],
  "provisioners": [{
    "type": "shell",
    "inline": [
      "sleep 30",
      "sudo apt-get update",
      "sudo apt-get install -y redis-server"
    ]
  }]
}


Run with below command: 
$ packer build \
    -var 'aws_access_key=YOUR ACCESS KEY' \
    -var 'aws_secret_key=YOUR SECRET KEY' \
    -var 'do_api_token=YOUR API TOKEN' \
    example.json


Note: In case if you want to build only one 
      packer build -only=amazon-ebs example.json

 

7. Extending to Packer:  create an plugins,custome  builder, provisioners and post-processors 
   Environment variables : https://www.packer.io/docs/other/environment-variables.html
   Debugging : packer build -on-error=ask , packer build -debug  [for remote builds]
   




