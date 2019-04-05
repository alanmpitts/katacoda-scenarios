#!/bin/sh

# turn off signature checking for kubernetes packages
echo 'Acquire::https::packages.cloud.google.com::Verify-Peer "false";' >> /etc/apt/apt.conf

# tell dpkg that installs are not interactive
export DEBIAN_FRONTEND=noninteractive
# install a few fundimental packages
apt-get update && apt-get install -y apt-transport-https apt-transport-https ca-certificates curl software-properties-common conntrack

# get the keys for docker & k8s packages
curl -kfsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - 
curl -ks https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

# add Docker CE repo
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" 
# add the k8s repo
add-apt-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"


# Install Docker CE


## Install Docker CE.
apt-get -y update && apt-get install -y docker-ce=18.06.2~ce~3-0~ubuntu

mkdir -p /etc/docker
# Setup daemon.
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

# Restart docker.
systemctl daemon-reload
systemctl restart docker


# install docker ce
## to get a specific version of docker-ce do this.
# apt-get install docker-ce=18.06.0~ce~3-0~ubuntu kubeadm=1.12.1-00 kubelet=1.12.1-00 kubectl=1.12.1-00
apt-get install -y kubeadm kubelet kubectl
# apt-get update && apt-get install -y docker-ce kubelet kubeadm kubectl
swapoff -a
sed -i '/swap/{ s|^|#| }' /etc/fstab
