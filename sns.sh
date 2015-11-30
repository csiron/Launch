#!/usr/local/bin/bash

ARN=(`aws sns create-topic --name cjsmp2`)

echo "this is arn: $ARN"

aws sns set-topic-attributes --topic-arn $ARN --attribute-name DisplayName --attribute-value mp2

aws sns subscribe --topic-arn $ARN --protocol email --notification-endpoint csiron@hawk.iit.edu
