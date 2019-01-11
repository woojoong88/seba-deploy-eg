#! /usr/bin/env bash

echo "this is the ONF SEBA deployment in a single physical machine"

echo "start to install prerequisites"
sudo apt update
sudo apt-get install python -y
sudo apt-get install python-pip -y
pip install requests
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

echo "install minikube and kubectl"
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
sudo mv minikube /usr/local/bin/
curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

export MINIKUBE_WANTUPDATENOTIFICATION=false
export MINIKUBE_WANTREPORTERRORPROMPT=false
export MINIKUBE_HOME=$HOME
export CHANGE_MINIKUBE_NONE_USER=true
mkdir -p $HOME/.kube
touch $HOME/.kube/config

export KUBECONFIG=$HOME/.kube/config

sudo -E ./minikube start --vm-driver=none

echo "need to push below commands"
echo "\$sudo updatedb"
echo "\$locate kubeconfig"
echo "\$export KUBECONFIG=/var/lib/localkube/kubeconfig"
