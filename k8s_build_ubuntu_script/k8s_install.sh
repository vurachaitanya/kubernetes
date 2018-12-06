#!/bin/bash

#sudo apt-get update && apt-get install -y apt-transport-https
sleep 2
echo "updating repos..."

#if [[ $? == 0 ]]
#then
sudo apt install docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add 
sudo cat << EOF > /etc/apt/sources.list.d/kubernetes.list 
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
#fi

apt-get update
sleep 3
apt-get install -y kubelet kubeadm kubectl kubernetes-cni
sleep 2
sudo kubeadm init

#mkdir -p $HOME/.kube
#sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
#sudo chown $(id -u):$(id -g) $HOME/.kube/config
#sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
#sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/k8s-manifests/kube-flannel-rbac.yml
