#!/bin/bash

# Required Variables (Add these values according to your confs)
USERNAME=""
GROUPNAME=""
PUBLIC_KEY=""

# Shell Script Functions
command_exists() {
	command -v "$1" >/dev/null 2>&1
}

#-- -----------------------------------------------------------------------------------
#-- Shell Script Code -----------------------------------------------------------------
#-- -----------------------------------------------------------------------------------

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

# install java
if ! command_exists java || [[ "$(java -version 2>&1 | grep 'java version')" == "" ]]; then
	sudo yum install -y java java-devel
fi

# install kubectl
curl -fsSL -o /tmp/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.29.0/bin/linux/amd64/kubectl
chmod +x /tmp/kubectl
mkdir -p /home/"${USERNAME}"/bin && mv /tmp/kubectl /home/"${USERNAME}"/bin/kubectl && export PATH="${PATH}":/home/"${USERNAME}"/bin

# install helm
curl -fsSL -o /tmp/get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod +x /tmp/get_helm.sh
sh /tmp/get_helm.sh

# install terraform
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform

# install docker
sudo yum -y install docker

if [ "$?" -eq 0 ]; then
	sudo usermod -aG docker "${USERNAME}"
	sudo systemctl enable docker
	sudo systemctl start docker
fi
