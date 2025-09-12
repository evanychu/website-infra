# EC2

Code to deploy and delete an EC2 instance. It uses the launch template that is defined in
another directory.

## userdata.sh
This script configures the EC2 instance during the first boot after creation.

## setup-dev-env.sh
This script further configures the EC2 instance with tools for development.
1. Install AWS CLI version 2.

1. Get the private GitHub access token from AWS Systems Manager Parameter Store for authentication.

1. Install GitHub CLI.

1. Use GitHub CLI to clone the source code's repository because GitHub CLI handles the authentication with GitHub using the access token.
