#!/bin/bash
aws ec2 run-instances --image-id $1 --count $2 --instance-type $3 --key-name $4 --security-group-ids $5 --subnet-id $6 --iam-instance-profile $7 --associate-public-ip-address
aws wait instance-running
aws create-load-balancer --load-balancer-name csironITMO444loadbalancer --listeners "Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=80"
