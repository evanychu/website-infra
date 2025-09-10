#!/bin/bash -ex
# Setup development environment. Assume running as ubuntu user.

# Install AWS CLI v2.
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm awscliv2.zip

echo "Press ENTER to continue..."
read
# Configure GitHub access token.
GitHubToken=$(aws ssm get-parameter \
  --name "EvanChuGitHubToken" \
  --with-decryption \
  --region "us-east-1" \
  --query "Parameter.Value" \
  --output text)
export GITHUB_TOKEN="${GitHubToken}"
echo "export GITHUB_TOKEN=${GitHubToken}" >> ~/.bashrc

echo "Press ENTER to continue..."
read
# GitHub CLI: https://cli.github.com/
# Install: https://github.com/cli/cli/blob/trunk/docs/install_linux.md#debian
(type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
	&& out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
	&& cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& sudo mkdir -p -m 755 /etc/apt/sources.list.d \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y

echo "Press ENTER to continue..."
read
# Setup directories for website.
sudo mkdir -p /mnt/box
sudo chown ubuntu:ubuntu /mnt/box
sudo chmod a+rwx /mnt/box
sudo ln -s /mnt/box /var/www/html/box
ln -s /mnt/box /home/ubuntu/box

# Change to the website directory.
cd /mnt/box

# Create a test for PHP with Apache.
cat > phpinfo.php << END
test 1 begin.
<?php
phpinfo();
?>
test 1 end.
END

echo "Press ENTER to continue..."
read
gh repo clone https://github.com/evanychu/web-01.git test3

echo "Press ENTER to continue..."
read
# Restart Apache.
sudo service apache2 status
sudo service apache2 restart
