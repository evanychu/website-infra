#!/bin/bash -xe
# Delete a CloudFormation stack for EC2 launch template.

source global-vars.sh
aws cloudformation delete-stack --stack-name "${StackName}"
