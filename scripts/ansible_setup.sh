#!/bin/bash
sudo apt update -y
sudo apt install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt update -y
sudo apt install ansible -y
ansible --version
sudo useradd devopsadmin -s /bin/bash -m -d /home/devopsadmin
su - devopsadmin -c 'ssh-keygen -t ecdsa -b 521 -f ~/.ssh/id_ecdsa -N ""'
sudo chown -R devopsadmin:devopsadmin /etc/ansible