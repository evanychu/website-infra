#!/bin/bash -xe
# Create a CloudFormation stack for EC2.

# The IAM user that runs this script must have the "iam:PassRole" permission
# to pass the role to the EC2 instance. See:
# https://aws.amazon.com/blogs/security/how-to-use-the-passrole-permission-with-iam-roles/

source global-vars.sh

# Parse exported CloudFormation variable "*-Ec2LaunchTemplateLatestVersion"
Ec2LaunchTemplateVersion=$(aws cloudformation list-exports --output json | jq --raw-output --arg VariableName "${Ec2LaunchTemplateStackName}-Ec2LaunchTemplateLatestVersion" '.Exports[] | select(.Name==$VariableName) | .Value')

# Parse exported CloudFormation variable "*-Ec2LaunchTemplateId"
Ec2LaunchTemplateId=$(aws cloudformation list-exports --output json | jq --raw-output --arg VariableName "${Ec2LaunchTemplateStackName}-Ec2LaunchTemplateId" '.Exports[] | select(.Name==$VariableName) | .Value')

aws cloudformation create-stack \
  --stack-name "${StackName}" \
  --template-body "file://${TemplateFileName}" \
  --parameters ParameterKey=Ec2Name,ParameterValue="${Ec2Name}" \
    ParameterKey=Ec2LaunchTemplateId,ParameterValue="${Ec2LaunchTemplateId}" \
    ParameterKey=Ec2LaunchTemplateVersion,ParameterValue="${Ec2LaunchTemplateVersion}"
