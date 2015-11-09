#!/bin/bash

declare -a instancesARR

mapfile -t instancesARR < <(aws ec2 run-instances --image-id $1 --count $2 --instance-type $3  --key-name $4 --security-group-ids $5 --subnet-id $6 --user-data file://environment/install-env.sh --associate-public-ip-address --output table | grep InstanceId | sed "s/|//g" | tr -d ' ' | sed "s/InstanceId//g")

echo ${instancesARR[@]}

aws ec2 wait instance-running --instance-ids ${instancesARR[@]} 

#aws elb create-load-balancer --load-balancer-name csironITMO444ELB --listeners "Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=80" --subnets subnet-0aa7a97d --security-groups sg-c7c2fea0

#aws elb configure-health-check --load-balancer-name csironITMO444ELB --health-check Target=HTTP:80/index.php,Interval=30,UnhealthyThreshold=2,HealthyThreshold=2,Timeout=3

#aws autoscaling create-launch-configuration --launch-configuration-name csironITMO444auto --image-id ami-d85e75b0 --key-name $4 --security-groups sg-c7c2fea0 --instance-type t1.micro --user-data file://environment/install-env.sh

#aws autoscaling create-auto-scaling-group --auto-scaling-group-name csironITMO444autogroup --launch-configuration-name csironITMO444auto --load-balancer-names csironITMO444ELB  --health-check-type ELB --min-size 1 --max-size 3 --desired-capacity 2 --default-cooldown 600 --health-check-grace-period 120 --vpc-zone-identifier subnet-0aa7a97d

