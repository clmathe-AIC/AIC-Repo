# Configure the AWS Provider
provider "aws" {
region = "us-east-1" # Specify your desired AWS region
}

# Data source to retrieve the latest Ubuntu AMI

data "aws_ami" "latest_RHEL9_ami" {
most_recent = true
owners = [904233107370""]
filter {
name = "name"
values = ["AMI_RHEL9-*"]
}
}

data "aws_ami" "latest_RHEL10_ami" {
most_recent = true
owners = ["904233107370"]
filter {
name = "name"
values = ["AMI_RHEL10-*"]
}
}

resource "aws_instance" "test_vm" {

ami = data.aws_ami.latest_RHEL9_ami.id
key_name = "ec2-test"
root_block_device {
volume_size = 50 # Sets the root volume size to 50 GiB
volume_type = "gp3" # Optional: specify volume type (e.g., gp2, gp3)
delete_on_termination = true # Optional: whether to delete volume on instance termination

}
vpc_security_group_ids = ["sg-0b572afa6c7ba24d4"]
instance_type = "t2.micro"
#associate_public_ip_address = true
subnet_id = "subnet-02914675f4e13b0d4"
tags = {
Name = "test terraform",
}
}
# Define the AWS Security Group
resource "aws_security_group" "terraform_server_sg" {
name = "terraform_server_security_group"
description = "Allow inbound HTTP and SSH traffic"
vpc_id = "vpc-0963a3d1f78e56fc0" # Replace with your VPC ID or reference

ingress {
from_port = 80
to_port = 80
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

ingress {
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

egress {
from_port = 0
to_port = 0
protocol = "-1" # Allows all outbound traffic
cidr_blocks = ["0.0.0.0/0"]

}
}
