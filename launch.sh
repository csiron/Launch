#!/bin/bash
aws ec2 run-instances --image-id $1 --count $2 --instance-type $3  --key-name $4 --security-group-ids $5 --subnet-id $6 --user-data file://environment/install-env.sh --associate-public-ip-address

aws ec2 describe-instances --filter Name=instance-state-code,Values=16 --output table | grep InstanceId | sed "s/|//g" | tr -d ' ' | sed "s/InstanceId//g"

mapfile -t instancesARR < <(aws ec2 describe-instances --filter Name=instance-state-code,Values=16 --output table | grep InstanceId | sed "s/|//g" | tr -d ' ' | sed "s/InstanceId//g")

aws ec2 wait instance-running --instance-ids ${instancesARR[@]} 

aws autoscaling create-launch-configuration --launch-configuration-name csironITMO444auto --image-id ami-d85e75b0 --key-name $4 --security-groups sg-c7c2fea0 --instance-type t1.micro --user-data file://environment/install-env.sh

aws autoscaling create-auto-scaling-group --auto-scaling-group-name csironITMO444autogroup --launch-configuration-name csironITMO444auto --load-balancer-names $2  --health-check-type ELB --min-size 1 --max-size 3 --desired-capacity 2 --default-cooldown 600 --health-check-grace-period 120 --vpc-zone-identifier subnet-0aa7a97d

