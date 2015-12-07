!/bin/bash

aws sns subscribe --topic-arn arn:aws:sns:us-east-1:$2:cjsmp2 --protocol sms --notification-endpoint $1 

aws sns add-permission --topic-arn arn:aws:sns:us-east-1:$2:cjsmp2 --label S3notification --aws-account-id $2 --action-name Publish

