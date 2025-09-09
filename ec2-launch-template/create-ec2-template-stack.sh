#!/bin/bash -xe
# Create a CloudFormation stack for EC2 launch template.

source global-vars.sh

aws cloudformation create-stack \
  --stack-name "${StackName}" \
  --template-body "file://${TemplateFileName}" \
  --parameters ParameterKey=Name,ParameterValue="${LaunchTemplateName}" \
    ParameterKey=VersionDescription,ParameterValue="${VersionDescription}" \
    ParameterKey=AmiId,ParameterValue="${AmiId}" \
    ParameterKey=InstanceType,ParameterValue="${InstanceType}"
