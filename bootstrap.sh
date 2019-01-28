#!/bin/bash -vx
exec > /tmp/part-001.log 2>&1

# sleep until instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done

sudo yum install git -y
sudo pip install ansible

sudo chmod 600 /home/ec2-user/.ssh/AWSJenkinsWS-pem.pem
sudo mkdir /home/ec2-user/.aws
sudo mv /home/ec2-user/credentials /home/ec2-user/.aws/.

sudo chown -R ec2-user:ec2-user /home/ec2-user/.aws

sudo mkdir /devrepos
sudo chown -R ec2-user:ec2-user /devrepos

cd /devrepos
git clone https://github.com/JonB32/conf_ecp.git

cd /devrepos/conf_ecp

/usr/local/bin/ansible-playbook site.yml
