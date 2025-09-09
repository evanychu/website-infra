#!/bin/bash -xe
source global-vars.sh
aws cloudformation delete-stack --stack-name "${StackName}"
