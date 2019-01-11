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
sudo apt-get install socat -y

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

PATH_KUBECONFIG=$(locate kubeconfig | grep -e "kubeconfig$")

sudo -E minikube start --vm-driver=none

rm -rf ~/seba_env_simple.sh
cat << EOF > ~/seba_env_simple.sh 
export MINIKUBE_WANTUPDATENOTIFICATION=false 
export MINIKUBE_WANTREPORTERRORPROMPT=false 
export MINIKUBE_HOME=$HOME 
export CHANGE_MINIKUBE_NONE_USER=true 
export KUBECONFIG=$PATH_KUBECONFIG
EOF

chmod 755 ~/seba_env_simple.sh

echo "" >> ~/.bashrc
echo "source ~/seba_env_simple.sh" >> ~/.bashrc

echo "Download CORD"
mkdir ~/cord
cd ~/cord
git clone https://gerrit.opencord.org/helm-charts

echo "Download helm"
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > ~/get_helm.sh
chmod 700 ~/get_helm.sh
~/get_helm.sh

echo "Tiller"
sudo helm init
sudo kubectl create serviceaccount --namespace kube-system tiller
sudo kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
sudo kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'      
sudo helm init --service-account tiller --upgrade

