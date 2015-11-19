#!/bin/bash


ARN=(`aws sns create-topic --name csironmp2`)

echo "This is the ARN:  $ARN"

aws sns set-topic-attributes --topic-arn $ARN --attribute-name DisplayName --attribute-value csironmp2

aws sns subscribe --topic-arn $ARN --protocol sms --notification-endpoint 18154822265 
