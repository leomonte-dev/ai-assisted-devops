#!/bin/bash

############################
# Description: Create VPC in AWS
# - Create VPC
# - Create a public subnet
#
# - Verify if users have AWS Installed, user might be using windows, linux or mac
# - Verify if AWS CLI is configured
##################################

# Variables
VPC_CIDR="10.0.0.0/16"
SUBNET_CIDR="10.0.3.0/24"
REGION="us-east-1"
VPC_NAME="demo-vpc-ai"
SUBNET_NAME="demo-subnet-ai"
SUBNET_AZ="us-east-1a"

# Verify if AWS CLI is installed
if ! [ -x "$(command -v aws)" ]; then
  echo "AWS CLI is not installed. Please install it first."
  exit 1
fi

# Verify if AWS CLI is configured
aws sts get-caller-identity &>/dev/null
if [ $? -ne 0 ]; then
  echo "AWS CLI is not configured. Please configure it by running 'aws configure'."
  exit 1
fi

# Create VPC
echo "Creating VPC..."
VPC_ID=$(aws ec2 create-vpc --cidr-block $VPC_CIDR --query 'Vpc.{VpcId:VpcId}' --output text)

# Add Name tag to VPC
aws ec2 create-tags --resources $VPC_ID --tags "Key=Name,Value=$VPC_NAME"

# Create Subnet
echo "Creating Subnet..."
SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $SUBNET_CIDR --availability-zone $SUBNET_AZ --query 'Subnet.{SubnetId:SubnetId}' --output text)

# Add Name tag to Subnet
aws ec2 create-tags --resources $SUBNET_ID --tags "Key=Name,Value=$SUBNET_NAME"


echo "VPC ID '$VPC_ID' and Subnet ID '$SUBNET_ID' created."


# End of script