#!/bin/bash

ARN=(`aws sns create-topic --name csironmp2`)

echo "This is the ARN:  $ARN"

aws sns set-topic-attributes --topic-arn $ARN --attribute-name DisplayName --attribute-value csironmp2

aws sns subscribe --topic-arn $ARN --protocol sms --notification-endpoint 18154822265 

aws sns add-permission --topic-arn $ARN --label S3notification --aws-account-id $1 --action-name Publish

echo "Waiting for two minutes to allow the subscriber to respond to the sms text"

sleep 120 #wait command added to allow time for subscriber to respond to text to confirm subscription

aws s3api create-bucket --bucket cjs-sns-testbucket --acl public-read --region us-east-1

sleep 300
echo "Waiting for five minutes for bucket to be completely initialized"

aws s3api put-bucket-notification --bucket cjs-sns-testbucket --notification-configuration file://test.json
