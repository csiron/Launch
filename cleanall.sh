#!/usr/local/bin/bash

declare -a cleanupARR
declare -a cleanupLBARR
declare -a dbInstanceARR

aws ec2 describe-instances --filter Name=instance-state-code,Values=16 --output table | grep InstanceId | sed "s/|//g" | tr -d ' ' | sed "s/InstanceId//g"

mapfile -t cleanupARR < <(aws ec2 describe-instances --filter Name=instance-state-code,Values=16 --output table | grep InstanceId | sed "s/|//g" | tr -d ' ' | sed "s/InstanceId//g")

aws ec2 terminate-instances --instance-ids ${cleanupARR[@]} 

sleep 5

mapfile -t loadbalancersARR < <(aws elb describe-load-balancers --output json | grep LoadBalancerName | sed "s/[\"\:\, ]//g" | sed "s/LoadBalancerName//g")

LENGTH=${#loadbalancersARR[@]}
echo "ARRAY LENGTH IS $LENGTH"
for (( i=0; i<${LENGTH}; i++)); 
  do
  aws elb delete-load-balancer --load-balancer-name ${cleanupLBARR[i]} --output text
done

sleep 5

aws cloudwatch delete-alarms --alarm-names Raise

sleep 5

aws cloudwatch delete-alarms --alarm-names Lower

sleep 5

 mapfile -t dbcleanupARR < <(aws rds describe-db-instances --output json | grep "\"DBInstanceIdentifier" | sed "s/[\"\:\, ]//g" | sed "s/DBInstanceIdentifier//g" )

if [ ${#dbcleanupARR[@]} -gt 0 ]
   then
  echo "Deleting existing RDS database-instances"
   LENGTH=${#dbInstanceARR[@]}  

      for (( i=0; i<${LENGTH}; i++));
      do 
      aws rds delete-db-instance --db-instance-identifier ${dbcleanupARR[i]} --skip-final-snapshot --output text
      aws rds wait db-instance-deleted --db-instance-identifier ${dbcleanupARR[i]} --output text
   done
fi

sleep 5

LAUNCHCONFIG=(`aws autoscaling describe-launch-configurations --output json | grep LaunchConfigurationName | sed "s/[\"\:\, ]//g" | sed "s/LaunchConfigurationName//g"`)

AUTOGROUPS=(`aws autoscaling describe-auto-scaling-groups --output json | grep AutoScalingGroupName | sed "s/[\"\:\, ]//g" | sed "s/AutoScalingGroupName//g"`)

if [ ${#AUTOGROUPS[@]} -gt 0 ]
  then

aws autoscaling update-auto-scaling-group --auto-scaling-group-name $AUTOGROUPS --min-size 0 --max-size 0

sleep 5

aws autoscaling delete-auto-scaling-group --auto-scaling-group-name $AUTOGROUPS --force-delete

sleep 5

aws autoscaling delete-launch-configuration --launch-configuration-name $LAUNCHCONF

sleep 5

fi

aws sns delete-topic --topic-arn arn:aws:sns:us-east-1:919217163828:cjsmp2

echo "Hopefully everything is deleted"
