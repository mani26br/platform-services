#!/bin/bash

# Install the SSM agent using the official Amazon Linux 2 package
echo "Installing SSM agent..."
sudo dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm

# Start the SSM agent service
echo "Starting SSM agent..."
systemctl start amazon-ssm-agent

# Enable the SSM agent to start on boot
echo "Enabling SSM agent to start on boot..."
systemctl enable amazon-ssm-agent

echo "SSM agent installation and setup completed."