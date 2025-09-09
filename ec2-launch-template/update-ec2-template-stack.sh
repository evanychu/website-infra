#!/bin/bash -xe
# Update a CloudFormation stack for EC2 launch template.

source global-vars.sh
VersionDescription="new version"

# Update the CloudFormation stack with new parameters.
# https://docs.aws.amazon.com/cli/latest/reference/cloudformation/update-stack.html#
aws cloudformation update-stack \
  --stack-name "${StackName}" \
  --template-body "file://${TemplateFileName}" \
  --parameters ParameterKey=Name,ParameterValue="${LaunchTemplateName}" \
    ParameterKey=VersionDescription,ParameterValue="${VersionDescription}" \
    ParameterKey=AmiId,ParameterValue="${AmiId}" \
    ParameterKey=InstanceType,ParameterValue="${InstanceType}"

aws cloudformation wait stack-update-complete --stack-name "${StackName}"

# Parse exported CloudFormation variable "*-Ec2LaunchTemplateLatestVersion"
LatestVersion=$(aws cloudformation list-exports --output json | jq --raw-output --arg VariableName "${StackName}-Ec2LaunchTemplateLatestVersion" '.Exports[] | select(.Name==$VariableName) | .Value')

# Parse exported CloudFormation variable "*-Ec2LaunchTemplateId"
LaunchTemplateId=$(aws cloudformation list-exports --output json | jq --raw-output --arg VariableName "${StackName}-Ec2LaunchTemplateId" '.Exports[] | select(.Name==$VariableName) | .Value')

# Set the default version to the latest version.
# https://docs.aws.amazon.com/cli/latest/reference/ec2/modify-launch-template.html
aws ec2 modify-launch-template --launch-template-id ${LaunchTemplateId} --default-version ${LatestVersion}
