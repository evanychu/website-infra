#!/bin/bash -xe
# Update a CloudFormation stack for EC2 launch template.

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

# Parse exported CloudFormation variable "*-Ec2LaunchTemplateLatestVersion"
LatestVersion=$(aws cloudformation list-exports --output json | jq --raw-output --arg VariableName "${StackName}-Ec2LaunchTemplateLatestVersion" '.Exports[] | select(.Name==$VariableName) | .Value')

# Parse exported CloudFormation variable "*-Ec2LaunchTemplateId"
LaunchTemplateId=$(aws cloudformation list-exports --output json | jq --raw-output --arg VariableName "${StackName}-Ec2LaunchTemplateId" '.Exports[] | select(.Name==$VariableName) | .Value')

# Set the default version to the latest version.
# https://docs.aws.amazon.com/cli/latest/reference/ec2/modify-launch-template.html
aws ec2 modify-launch-template --launch-template-id ${LaunchTemplateId} --default-version ${LatestVersion}
