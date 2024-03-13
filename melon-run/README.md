```
kind create cluster --name melon-run --image kindest/node:v1.28.7
kind get kubeconfig --name melon-run | sed 's/kind-melon-run/melon-run/g' > ~/.kube/config.melon-run
```

```
pivnet download-product-files --product-slug='tanzu-cluster-essentials' --release-version='1.8.0' --glob='tanzu-cluster-essentials-darwin-amd64-*'

TANZUNET_USERNAME=...
TANZUNET_PASSWORD=...

mkdir tanzu-cluster-essentials
tar xzvf tanzu-cluster-essentials-*-amd64-*.tgz -C tanzu-cluster-essentials

export INSTALL_BUNDLE=registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle:1.8.0
export INSTALL_REGISTRY_HOSTNAME=registry.tanzu.vmware.com
export INSTALL_REGISTRY_USERNAME=${TANZUNET_USERNAME}
export INSTALL_REGISTRY_PASSWORD=${TANZUNET_PASSWORD}
cd tanzu-cluster-essentials
./install.sh --yes
cd ..
```

```
NAMESPACE=kapp
kubectl create ns ${NAMESPACE}
kubectl create -n ${NAMESPACE} sa kapp
kubectl create clusterrolebinding kapp-cluster-admin-${NAMESPACE} --clusterrole cluster-admin --serviceaccount=${NAMESPACE}:kapp
kubectl create secret generic -n ${NAMESPACE} github --from-file=ssh-privatekey=$HOME/.ssh/id_rsa --dry-run=client -oyaml | kubectl apply -f-
kubectl create secret generic -n ${NAMESPACE} pgp-key --from-file=$HOME/.gnupg/my.pk --dry-run=client -oyaml | kubectl apply -f-
```

```
kubectl apply -f ~/git/k8s-manifests/melon-run/kapp/apps.yaml
```

```
cat <<EOF > ~/git/k8s-manifests/melon-run/docker-compose.yaml
services:
  inlets:
    image: ghcr.io/making/inlets:2.7.6
    platform: linux/amd64
    restart: always
    command: client --remote=wss://$(kubectl get httpproxy --context kiwi-view -n inlets inlets -ojsonpath='{.spec.virtualhost.fqdn}') --upstream=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}' --context melon-run | sed 's/127.0.0.1/host.docker.internal/') --token=$(kubectl get secret --context kiwi-view -n inlets inlets-token -otemplate='{{.data.token | base64decode}}')
EOF
pushd ~/git/k8s-manifests/melon-run
docker-compose up -d
popd
```