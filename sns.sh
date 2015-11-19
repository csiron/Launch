#!/bin/bash

ARN=(`aws sns create-topic --name csironmp2`)

echo "This is the ARN:  $ARN"

aws sns set-topic-attributes --topic-arn $ARN --attribute-name DisplayName --attribute-value csironmp2

aws sns subscribe --topic-arn $ARN --protocol sms --notification-endpoint 18154822265 

echo "Waiting for one minute to allow the subscriber to respond to the sms text"

sleep 60 #wait command added to allow time for subscriber to respond to text to confirm subscription

aws s3 mb s3://snstest-bucket

wait bucket-exists --bucket snstest-bucket

aws s3api put-bucket-notification-configuration --bucket snstest-bucket --notification-configuration file://bucketconfig.json


