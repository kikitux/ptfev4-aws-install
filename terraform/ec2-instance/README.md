# PTFEv4 EC2 Instance

**DEPRICATED:** This module is not used in the root Terraform module. It is replaced with `asg-ec2-instance`.

A Terraform configuration to build an EC2 instance with PTFEv4 installed. The PTFE installation will external services - AWS S3 and AWS PostgreSQL RDS.

The configuration assumes that it is provided an AMI built with the Packer [project](../packer/README.md) in this repo.

## Description

The Terraform configuration provisions:

- An AWS role which allows the created EC2 instance full access to S3 resources

- Security group which allows network traffic from the EC2 instance according to the TFE [documentation](https://www.terraform.io/docs/enterprise/before-installing/network-requirements.html).

- An EC2 instance based on the specific AMI. The user data will be set to:
  
  - create an `/ect/replicated.conf` file based on the input variables.
  - create an `/opt/tfe-installer/settings.conf` file based on the input variables.
  - Run the replicated installation script according to the TFE [documentation](https://www.terraform.io/docs/enterprise/install/automating-the-installer.html) using the created settings files.

## Usage

For instructions on how to run Terraform configuration refer to the root module [readme](../README.md#Usage).
