#!/bin/bash

#if you wanted to use a source_ami instead of a source_ami_filter it might look something like this: "source_ami": "ami-fce3c696",

export AWS_ACCESS_KEY_ID=MYACCESSKEYID
export AWS_SECRET_ACCESS_KEY=MYSECRETACCESSKEY
export PATH=$PATH:/usr/local/bin/packer
packer build example_ami.json
