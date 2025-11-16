#!/bin/bash
sudo swapoff -a
sudo sed -e '/swap/ s/^#*/#/' -i /etc/fstab
sudo systemctl mask swap.target
sudo bash -c 'echo "net.ipv4.ip_forward=1" > /usr/lib/sysctl.d/100-k8s.conf'
sudo dnf install cri-o crun container-selinux -y
sudo systemctl enable crio --now

sudo cat << EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.34/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.34/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF

sudo dnf install -y kubelet kubeadm kubectl --setopt=exclude=
sudo dnf versionlock add kubernetes*-1.34.* cri-o-1.32.*
sudo systemctl enable --now kubelet
sudo kubeadm init --v=5

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
sudo kubectl taint nodes --all node-role.kubernetes.io/control-plane-
# disable firewall or coredns pods will be stuck in pending
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo kubectl get node
sudo kubectl get pod -A
