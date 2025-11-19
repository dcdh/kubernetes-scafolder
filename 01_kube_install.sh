#!/bin/bash
echo -e "\e[32mStart kubernetes installation\e[0m"
source /etc/os-release
if [[ "$PRETTY_NAME" != "Fedora Linux 43 (Server Edition)" ]]; then
    echo -e "\e[31m[ERROR]\e[0m Only run on Fedora Linux 43 (Server Edition)"
    echo -e "\e[31m[ERROR]\e[0m OS detected : $PRETTY_NAME"
    exit 1
fi
if [[ $EUID -ne 0 ]]; then
    echo -e "\e[31m[ERROR]\e[0m must be run using sudo."
    exit 1
fi

IP=$(ip -4 -o addr show enp0s3 | awk '{print $4}' | cut -d/ -f1)

if [[ "$IP" == 192.168.* ]]; then
    echo -e "\e[32m[OK]\e[0m enp0s3 = $IP"
else
    echo -e "\e[31m[ERROR]\e[0m enp0s3 n'est pas en 192.168.x.x (IP = $IP)"
    exit 1
fi

swapoff -a
sed -e '/swap/ s/^#*/#/' -i /etc/fstab
systemctl mask swap.target
sysctl -w net.ipv4.ip_forward=1
bash -c 'echo "net.ipv4.ip_forward=1" > /usr/lib/sysctl.d/100-k8s.conf'
dnf install cri-o crun container-selinux -y
systemctl enable crio --now

cat << EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.34/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.34/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF

dnf install -y kubelet kubeadm kubectl --setopt=exclude=
dnf versionlock add kubernetes*-1.34.* cri-o-1.32.*
systemctl enable --now kubelet
kubeadm init --v=5

mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
# disable firewall or coredns pods will be stuck in pending
systemctl stop firewalld
systemctl disable firewalld
kubectl get node
kubectl get pod -A

echo -e "\e[32mHelm download\e[0m"
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod +x get_helm.sh
./get_helm.sh
rm get_helm.sh -f
