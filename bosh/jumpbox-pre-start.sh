#!/bin/bash
set -euox pipefail

mkdir -p /var/vcap/store/docker
mkdir -p /var/vcap/store/containerd
set +e
ln -s /var/vcap/store/docker /var/lib/docker
ln -s /var/vcap/store/containerd /var/lib/containerd
set -e

########## Install CLI from internet
export INSTALLATION=/var/vcap/store/installation
mkdir -p ${INSTALLATION}/bin ${INSTALLATION}/rec
cat <<'EOF' > /etc/profile.d/00-installation.sh
export INSTALLATION=/var/vcap/store/installation
export PATH=${PATH}:${INSTALLATION}/bin
EOF

CONTAINERD_VERSION=1.4.12-1
if [ ! -f ${INSTALLATION}/rec/containerd-${CONTAINERD_VERSION} ];then
  wget -O- https://download.docker.com/linux/ubuntu/dists/bionic/pool/stable/amd64/containerd.io_${CONTAINERD_VERSION}_amd64.deb > /tmp/containerd.io_${CONTAINERD_VERSION}_amd64.deb
  dpkg -i /tmp/containerd.io_${CONTAINERD_VERSION}_amd64.deb
  rm -f /tmp/containerd.io_${CONTAINERD_VERSION}_amd64.deb
  touch ${INSTALLATION}/rec/containerd-${CONTAINERD_VERSION}
fi

DOCKER_VERSION=20.10.12~3-0
if [ ! -f ${INSTALLATION}/rec/docker-${DOCKER_VERSION} ];then
  wget -O- https://download.docker.com/linux/ubuntu/dists/bionic/pool/stable/amd64/docker-ce-cli_${DOCKER_VERSION}~ubuntu-bionic_amd64.deb > /tmp/docker-ce-cli_${DOCKER_VERSION}~ubuntu-bionic_amd64.deb
  wget -O- https://download.docker.com/linux/ubuntu/dists/bionic/pool/stable/amd64/docker-ce_${DOCKER_VERSION}~ubuntu-bionic_amd64.deb > /tmp/docker-ce_${DOCKER_VERSION}~ubuntu-bionic_amd64.deb
  dpkg -i /tmp/docker-ce-cli_${DOCKER_VERSION}~ubuntu-bionic_amd64.deb /tmp/docker-ce_${DOCKER_VERSION}~ubuntu-bionic_amd64.deb
  rm -f /tmp/docker-ce-cli_${DOCKER_VERSION}~ubuntu-bionic_amd64.deb /tmp/docker-ce_${DOCKER_VERSION}~ubuntu-bionic_amd64.deb
  usermod -aG docker jumpbox
  touch ${INSTALLATION}/rec/docker-${DOCKER_VERSION}
fi

JDK_VERSION=17.0.1+12
if [ ! -f ${INSTALLATION}/rec/jdk-${JDK_VERSION} ];then
  wget -O- https://download.bell-sw.com/java/${JDK_VERSION}/bellsoft-jdk${JDK_VERSION}-linux-amd64.tar.gz > /tmp/jdk.tgz
  tar xzvf /tmp/jdk.tgz
  mv jdk* ${INSTALLATION}/
  rm -f /tmp/jdk.tgz
  echo "export JAVA_HOME=$(dirname ${INSTALLATION}/jdk-*/bin/)" | sudo tee -a /etc/profile.d/01-java.sh > /dev/null
  echo 'export JRE_HOME=${JAVA_HOME}' | sudo tee -a /etc/profile.d/01-java.sh > /dev/null
  echo 'export PATH=${PATH}:${JAVA_HOME}/bin' | sudo tee -a /etc/profile.d/01-java.sh > /dev/null
  touch ${INSTALLATION}/rec/jdk-${JDK_VERSION}
fi

BOSH_VERSION=6.4.10
if [ ! -f ${INSTALLATION}/rec/bosh-${BOSH_VERSION} ];then
  wget -O- https://github.com/cloudfoundry/bosh-cli/releases/download/v${BOSH_VERSION}/bosh-cli-${BOSH_VERSION}-linux-amd64 > /tmp/bosh
  mv /tmp/bosh ${INSTALLATION}/bin/bosh
  chmod +x ${INSTALLATION}/bin/bosh
  touch ${INSTALLATION}/rec/bosh-${BOSH_VERSION}
fi

PIVNET_VERSION=3.0.1
if [ ! -f ${INSTALLATION}/rec/pivnet-${PIVNET_VERSION} ];then
  wget -O- https://github.com/pivotal-cf/pivnet-cli/releases/download/v${PIVNET_VERSION}/pivnet-linux-amd64-${PIVNET_VERSION} > /tmp/pivnet
  mv /tmp/pivnet ${INSTALLATION}/bin/pivnet
  chmod +x ${INSTALLATION}/bin/pivnet
  touch ${INSTALLATION}/rec/pivnet-${PIVNET_VERSION}
fi

YJ_VERSION=v5.0.0
if [ ! -f ${INSTALLATION}/rec/yj-${YJ_VERSION} ];then
  wget -O- https://github.com/sclevine/yj/releases/download/${YJ_VERSION}/yj-linux > /tmp/yj
  mv /tmp/yj ${INSTALLATION}/bin/yj
  chmod +x ${INSTALLATION}/bin/yj
  touch ${INSTALLATION}/rec/yj-${YJ_VERSION}
fi

TERRAFORM_VERSION=1.1.2
if [ ! -f ${INSTALLATION}/rec/terraform-${TERRAFORM_VERSION} ];then
  wget -O- https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip > /tmp/terraform.zip
  unzip /tmp/terraform.zip
  mv terraform ${INSTALLATION}/bin/terraform
  rm -f /tmp/terraform.zip
  chmod +x ${INSTALLATION}/bin/terraform
  touch ${INSTALLATION}/rec/terraform-${TERRAFORM_VERSION}
fi

KUBECTL_VERSION=v1.22.2
if [ ! -f ${INSTALLATION}/rec/kubectl-${KUBECTL_VERSION} ];then
  wget -O- https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl > /tmp/kubectl
  mv /tmp/kubectl ${INSTALLATION}/bin/kubectl
  chmod +x ${INSTALLATION}/bin/kubectl
  touch ${INSTALLATION}/rec/kubectl-${KUBECTL_VERSION}
fi

HELM_VERSION=3.7.2
if [ ! -f ${INSTALLATION}/rec/helm-${HELM_VERSION} ];then
  wget -O- https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz > /tmp/helm.tgz
  tar xzvf /tmp/helm.tgz
  mv linux-amd64/helm ${INSTALLATION}/bin/helm
  rm -rf linux-amd64
  rm -f /tmp/helm.tgz
  chmod +x ${INSTALLATION}/bin/helm
  touch ${INSTALLATION}/rec/helm-${HELM_VERSION}
fi

YTT_VERSION=v0.38.0
if [ ! -f ${INSTALLATION}/rec/ytt-${YTT_VERSION} ];then
  wget -O- https://github.com/k14s/ytt/releases/download/${YTT_VERSION}/ytt-linux-amd64 > /tmp/ytt
  mv /tmp/ytt ${INSTALLATION}/bin/ytt
  chmod +x ${INSTALLATION}/bin/ytt
  touch ${INSTALLATION}/rec/ytt-${YTT_VERSION}
fi

KBLD_VERSION=v0.32.0
if [ ! -f ${INSTALLATION}/rec/kbld-${KBLD_VERSION} ];then
  wget -O- https://github.com/k14s/kbld/releases/download/${KBLD_VERSION}/kbld-linux-amd64 > /tmp/kbld
  mv /tmp/kbld ${INSTALLATION}/bin/kbld
  chmod +x ${INSTALLATION}/bin/kbld
  touch ${INSTALLATION}/rec/kbld-${KBLD_VERSION}
fi

KAPP_VERSION=v0.43.0
if [ ! -f ${INSTALLATION}/rec/kapp-${KAPP_VERSION} ];then
  wget -O- https://github.com/k14s/kapp/releases/download/${KAPP_VERSION}/kapp-linux-amd64 > /tmp/kapp
  mv /tmp/kapp ${INSTALLATION}/bin/kapp
  chmod +x ${INSTALLATION}/bin/kapp
  touch ${INSTALLATION}/rec/kapp-${KAPP_VERSION}
fi

KWT_VERSION=v0.0.6
if [ ! -f ${INSTALLATION}/rec/kwt-${KWT_VERSION} ];then
  wget -O- https://github.com/k14s/kwt/releases/download/${KWT_VERSION}/kwt-linux-amd64 > /tmp/kwt
  mv /tmp/kwt ${INSTALLATION}/bin/kwt
  chmod +x ${INSTALLATION}/bin/kwt
  touch ${INSTALLATION}/rec/kwt-${KWT_VERSION}
fi

IMGPKG_VERSION=v0.24.0
if [ ! -f ${INSTALLATION}/rec/imgpkg-${IMGPKG_VERSION} ];then
  wget -O- https://github.com/k14s/imgpkg/releases/download/${IMGPKG_VERSION}/imgpkg-linux-amd64 > /tmp/imgpkg
  mv /tmp/imgpkg ${INSTALLATION}/bin/imgpkg
  chmod +x ${INSTALLATION}/bin/imgpkg
  touch ${INSTALLATION}/rec/imgpkg-${IMGPKG_VERSION}
fi

VAULT_VERSION=1.9.1
if [ ! -f ${INSTALLATION}/rec/vault-${VAULT_VERSION} ];then
  wget -O- https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip> /tmp/vault.zip
  unzip /tmp/vault.zip
  mv vault ${INSTALLATION}/bin/vault
  rm -f /tmp/vault.zip
  chmod +x ${INSTALLATION}/bin/vault
  touch ${INSTALLATION}/rec/vault-${VAULT_VERSION}
fi

KIND_VERSION=0.11.1
if [ ! -f ${INSTALLATION}/rec/kind-${KIND_VERSION} ];then
  wget -O- https://kind.sigs.k8s.io/dl/v${KIND_VERSION}/kind-linux-amd64 > /tmp/kind
  mv /tmp/kind ${INSTALLATION}/bin/kind
  chmod +x ${INSTALLATION}/bin/kind
  touch ${INSTALLATION}/rec/kind-${KIND_VERSION}
fi

KP_VERSION=0.4.2
if [ ! -f ${INSTALLATION}/rec/kp-${KP_VERSION} ];then
  wget -O- https://github.com/vmware-tanzu/kpack-cli/releases/download/v${KP_VERSION}/kp-linux-${KP_VERSION} > /tmp/kp
  mv /tmp/kp ${INSTALLATION}/bin/kp
  chmod +x ${INSTALLATION}/bin/kp
  touch ${INSTALLATION}/rec/kp-${KP_VERSION}
fi
