# K8s build on Centos 7.6 and K8s 14.x

- hostonly network and updated the conf with static address on the network and give static. (Static, Boot, IP)
- yum install git curl
- disable swap(swapoff -a, update /etc/hosts), firewall (systemctl disable firewalld)
- Disable Selinux
- Install Docker : https://docs.docker.com/install/linux/docker-ce/centos/
- Installation steps : https://kubernetes.io/docs/setup/independent/install-kubeadm/
- Static IP used = 192.168.56.10 - Master,192.168.56.11 
- kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.56.10
- Execute all the commands given in the output.
- Networking: 
  - kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/canal/rbac.yaml
  - kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/canal/canal.yaml



