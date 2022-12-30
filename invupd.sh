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
    print_color "green" "The $1 was successfully"
  else
    print_color "red" "The $1 failed"
  fi
}



if [ "$(whoami)" != "root" ]; then
  print_color "red" "This script must be run as root"
  exit 1

fi



print_color "green" "Adding Container to Ansible Inventory"
echo "[Container]" >> /etc/ansible/hosts
echo "container1 ansible_host=$1 ansible_user=root" >> /etc/ansible/hosts
check_exit_code "Ansible inventory"


