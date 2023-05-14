#!/bin/bash
su - ubuntu
sudo apt-get update
sudo apt-get -y upgrade
sudo yum update -y

sudo yum -y install python-pip
sudo pip3 install flask

# sudo su - ec2-user
# sudo yum install ruby wget -y
# sudo cd /home/ec2-user
# sudo wget https://aws-codedeploy-eu-central-1.s3.eu-central-1.amazonaws.com/latest/install
# sudo chmod +x ./install
# sudo ./install auto

