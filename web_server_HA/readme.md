# Terraform: Zero Downtime Web Server Deployment

This project demonstrates how to create a highly available web server with zero downtime using Terraform and AWS, utilizing a Blue-Green Deployment strategy.

## Project Overview

This Terraform configuration sets up the following resources:
- **AWS Security Groups**: Configure security rules for inbound and outbound traffic.
- **AMI**: Use the latest Ubuntu AMI.
- **Launch Configuration**: Define settings for EC2 instances.
- **Auto Scaling Group**: Automatically scale EC2 instances based on demand.
- **Load Balancer**: Distribute traffic across instances to ensure high availability.
