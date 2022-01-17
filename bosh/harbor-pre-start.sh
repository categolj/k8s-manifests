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
wget -O- https://download.docker.com/linux/ubuntu/dists/bionic/pool/stable/amd64/containerd.io_${CONTAINERD_VERSION}_amd64.deb > /tmp/containerd.io_${CONTAINERD_VERSION}_amd64.deb
dpkg -i /tmp/containerd.io_${CONTAINERD_VERSION}_amd64.deb
rm -f /tmp/containerd.io_${CONTAINERD_VERSION}_amd64.deb

DOCKER_VERSION=20.10.12~3-0
wget -O- https://download.docker.com/linux/ubuntu/dists/bionic/pool/stable/amd64/docker-ce-cli_${DOCKER_VERSION}~ubuntu-bionic_amd64.deb > /tmp/docker-ce-cli_${DOCKER_VERSION}~ubuntu-bionic_amd64.deb
wget -O- https://download.docker.com/linux/ubuntu/dists/bionic/pool/stable/amd64/docker-ce_${DOCKER_VERSION}~ubuntu-bionic_amd64.deb > /tmp/docker-ce_${DOCKER_VERSION}~ubuntu-bionic_amd64.deb
dpkg -i /tmp/docker-ce-cli_${DOCKER_VERSION}~ubuntu-bionic_amd64.deb /tmp/docker-ce_${DOCKER_VERSION}~ubuntu-bionic_amd64.deb
rm -f /tmp/docker-ce-cli_${DOCKER_VERSION}~ubuntu-bionic_amd64.deb /tmp/docker-ce_${DOCKER_VERSION}~ubuntu-bionic_amd64.deb
usermod -aG docker harbor

DOCKER_COMPOSE_VERSION=2.2.2
if [ ! -f ${INSTALLATION}/rec/docker-compose-${DOCKER_COMPOSE_VERSION} ];then
  wget -O- https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-linux-x86_64 > /tmp/docker-compose
  mv /tmp/docker-compose ${INSTALLATION}/bin/docker-compose
  chmod +x ${INSTALLATION}/bin/docker-compose
  touch ${INSTALLATION}/rec/docker-compose-${DOCKER_COMPOSE_VERSION}
fi

HARBOR_VERSION=v2.4.1
if [ ! -f ${INSTALLATION}/rec/harbor-${HARBOR_VERSION} ];then
  wget -O- https://github.com/goharbor/harbor/releases/download/${HARBOR_VERSION}/harbor-offline-installer-${HARBOR_VERSION}.tgz > /tmp/harbor.tgz
  tar xzvf /tmp/harbor.tgz
  rm -rf ${INSTALLATION}/harbor
  mv harbor ${INSTALLATION}/harbor
  rm -f /tmp/harbor.tgz
  touch ${INSTALLATION}/rec/harbor-${HARBOR_VERSION}
fi

BOSH_VERSION=6.4.10
if [ ! -f ${INSTALLATION}/rec/bosh-${BOSH_VERSION} ];then
  wget -O- https://github.com/cloudfoundry/bosh-cli/releases/download/v${BOSH_VERSION}/bosh-cli-${BOSH_VERSION}-linux-amd64 > /tmp/bosh
  mv /tmp/bosh ${INSTALLATION}/bin/bosh
  chmod +x ${INSTALLATION}/bin/bosh
  touch ${INSTALLATION}/rec/bosh-${BOSH_VERSION}
fi

YJ_VERSION=v5.0.0
if [ ! -f ${INSTALLATION}/rec/yj-${YJ_VERSION} ];then
  wget -O- https://github.com/sclevine/yj/releases/download/${YJ_VERSION}/yj-linux > /tmp/yj
  mv /tmp/yj ${INSTALLATION}/bin/yj
  chmod +x ${INSTALLATION}/bin/yj
  touch ${INSTALLATION}/rec/yj-${YJ_VERSION}
fi

YTT_VERSION=v0.38.0
if [ ! -f ${INSTALLATION}/rec/ytt-${YTT_VERSION} ];then
  wget -O- https://github.com/k14s/ytt/releases/download/${YTT_VERSION}/ytt-linux-amd64 > /tmp/ytt
  mv /tmp/ytt ${INSTALLATION}/bin/ytt
  chmod +x ${INSTALLATION}/bin/ytt
  touch ${INSTALLATION}/rec/ytt-${YTT_VERSION}
fi

IMGPKG_VERSION=v0.24.0
if [ ! -f ${INSTALLATION}/rec/imgpkg-${IMGPKG_VERSION} ];then
  wget -O- https://github.com/k14s/imgpkg/releases/download/${IMGPKG_VERSION}/imgpkg-linux-amd64 > /tmp/imgpkg
  mv /tmp/imgpkg ${INSTALLATION}/bin/imgpkg
  chmod +x ${INSTALLATION}/bin/imgpkg
  touch ${INSTALLATION}/rec/imgpkg-${IMGPKG_VERSION}
fi

if [ ! -d /var/vcap/store/certs ];then
  mkdir -p /var/vcap/store/certs
  chown -R harbor:harbor /var/vcap/store/certs
  chmod u+rxw /var/vcap/store/certs
fi