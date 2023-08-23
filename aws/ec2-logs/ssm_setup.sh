#!/bin/bash

# Install the SSM agent for RHEL 9.x and 8.x and CentOS
echo "Installing SSM agent..."
sudo dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm

#install for RHEL 7.X
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm

# Start the SSM agent service
echo "Starting SSM agent..."
systemctl start amazon-ssm-agent

# Enable the SSM agent to start on boot
echo "Enabling SSM agent to start on boot..."
systemctl enable amazon-ssm-agent

echo "SSM agent installation and setup completed."