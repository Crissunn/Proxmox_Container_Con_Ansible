#!/bin/bash

# Author: Cristian A. Gomez
# Linkedin: https://www.linkedin.com/in/agcristian/


set -e

print_color(){
  NC='\033[0m' # No Color
  case $1 in
    "green") COLOR='\033[0;32m' ;;
    "red") COLOR='\033[0;31m' ;;
    *) COLOR='\033[0m' ;;
  esac

  echo -e "${COLOR} $2 ${NC}"
}


check_exit_code() {
  if [ $? -eq 0 ]; then
    print_color "green" "The $1 was successful"
  else
    print_color "red" "The $1 failed"
  fi
}



if [ "$(whoami)" != "root" ]; then
  print_color "red" "This script must be run as root"
  exit 1

fi

print_color "green" "Update OS"
yum update -y
check_exit_code "System Update"

print_color "green" "Installing Ansible"
yum install epel-release
yum install ansible -y 
check_exit_code "Ansible installation"

pip install proxmoxer requests
check_exit_code "Ansible proxmox request installation"

print_color "green" "Provide Proxmox IP"
read -p "Enter the Proxmox IP address: " ip_address

print_color "green" "Generating SSH pair keys"
ssh-keygen -t rsa
check_exit_code "SSH keys"

print_color "green" "Copy ssh pub key to $ip_address"
ssh-copy-id root@$ip_address
check_exit_code "SSH pub key copy"


print_color "green" "Installin Ansible proxmox request in target machine"
ssh root@$ip_address apt update -y
ssh root@$ip_address apt upgrade -y
ssh root@$ip_address apt install python3
ssh root@$ip_address pip install proxmoxer requests
check_exit_code "Ansible proxmox request installation"


print_color "green" "Create Ansible inventory file"
touch /etc/ansible/hosts
echo "[Proxmox]" >> /etc/ansible/hosts
echo "pve ansible_host=$ip_address ansible_user=ansible" >> /etc/ansible/hosts
check_exit_code "Ansible inventory"


