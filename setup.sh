#!/bin/bash
echo "start vagrant provioning..."

sudo apt-get update

echo "install docker..."
sudo apt-get install -y docker.io

echo "set docker launch at boot..."
sudo systemctl enable docker

echo "start docker..."
sudo systemctl start docker

echo "add signing key..."
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add

echo "install curl pkg..."
sudo apt-get install -y curl

echo "Add ubuntu to default repository..."
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"

echo "install kubectl"
sudo apt-get install -y  kubectl
sudo apt-mark hold  kubectl

echo "install http transport..."
sudo apt-get install apt-transport-https

echo "install kubectl..."
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl

chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version -o json

echo "install helm"
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install -y helm

echo "install golang packages"
sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt update -y
sudo apt-get -y install make golang redis-server
sudo systemctl restart redis.service

echo "Install dlv pkg"
 git clone https://github.com/go-delve/delve.git $GOPATH/src/github.com/go-delve/delve
 cd $GOPATH/src/github.com/go-delve/delve
 make install

echo "install kind"
echo export GO111MODULE="on" >> ~/.bashrc
go get sigs.k8s.io/kind@v0.10.0

### export dlv bin path
echo export PATH=$PATH:/home/vagrant/go/bin >> ~/.bashrc
echo export PATH=$PATH:/root/go/bin >> ~/.bashrc

curl -L -o opa https://openpolicyagent.org/downloads/latest/opa_linux_amd64
chmod 755 ./opa
sudo mv ./opa /usr/local/bin/opa
####create cluster
echo "Finished provisioning."
