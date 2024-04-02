#!/bin/bash

# Required Variables (Change these values according to your confs)
USERNAME="sysadmin"
GROUPNAME="devops"
PUBLIC_KEY="ssh-ed25519 HASHCODEXXX....."

# Shell Script Functions -------------------------------------------------------------------
command_exists() {
	command -v "$1" >/dev/null 2>&1
}

# Shell Script Code

# Create GROUPNAME/USERNAME
sudo groupadd "${GROUPNAME}"
echo "%${GROUPNAME} ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/"${GROUPNAME}"
sudo useradd -m -G "${GROUPNAME}" "${USERNAME}"

# Configure sysadmin ssh public key in authorized keys
sudo mkdir -p /home/"${USERNAME}"/.ssh
echo "${PUBLIC_KEY}" | sudo tee -a /home/"${USERNAME}"/.ssh/authorized_keys
sudo chown -R "${USERNAME}":"${GROUPNAME}" /home/"${USERNAME}"/.ssh
sudo chmod 440 /etc/sudoers.d/"${GROUPNAME}"
sudo chmod 700 /home/"${USERNAME}"/.ssh
sudo chmod 600 /home/"${USERNAME}"/.ssh/authorized_keys

# Requirements
packages=("wget" "fontconfig" "git" "yum-utils" "nmap-ncat")

for package in "${packages[@]}"; do
	if ! command_exists "${package}"; then
		sudo yum install -y "${package}"
	fi
done

if ! command_exists java || [[ "$(java -version 2>&1 | grep 'java version')" == "" ]]; then
	sudo yum install -y java java-devel
fi

# install terraform
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform

# install kubectl
sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.29.0/bin/linux/amd64/kubectl
sudo chmod +x ./kubectl
sudo mkdir -p /home/"${USERNAME}"/bin && sudo cp ./kubectl /home/"${USERNAME}"/bin/kubectl && export PATH="${PATH}":/home/"${USERNAME}"/bin

# install jenkins on AmazonLinux2
if [[ ! -f "/etc/yum.repos.d/jenkins.repo" ]]; then
	sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
	sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
fi

# Update && install jenkins
sudo yum upgrade -y
sudo yum install jenkins -y

# Jenkins Daemon
sudo systemctl enable jenkins && sudo systemctl start jenkins