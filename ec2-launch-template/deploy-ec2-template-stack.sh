#!/bin/bash -xe
# Deploy aCloudFormation stack for EC2 launch template.

source global-vars.sh

# https://docs.aws.amazon.com/cli/latest/reference/cloudformation/deploy.html
aws cloudformation deploy \
  --stack-name "${StackName}" \
  --template-file "${TemplateFileName}" \
  --parameter-overrides \
    Name="${LaunchTemplateName}" \
    VersionDescription="${VersionDescription}" \
    AmiId="${AmiId}" \
    InstanceType="${InstanceType}"
