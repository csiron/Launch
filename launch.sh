#!/bin/bash
aws ec2 run-instances --image-id $1 --count $2 --instance-type $3  --key-name $4 --security-group-ids $5 --subnet-id $6 --user-data file://environment/install-env.sh --associate-public-ip-address
aws ec2 wait instance-running
aws autoscaling create-launch-configuration --launch-configuration-name csironITMO444auto --image-id ami-d85e75b0 --key-name $4 --security-groups sg-c7c2fea0 --instance-type t1.micro --user-data file://environment/install-env.sh --iam-instance-profile csironPower


