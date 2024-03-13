```
kind create cluster --name melon-run --image kindest/node:v1.28.7
```

```
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.3/config/manifests/metallb-native.yaml
kubectl wait --namespace metallb-system \
             --for=condition=ready pod \
             --selector=app=metallb \
             --timeout=90s
```

```
kubectl apply -f- << EOF
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: example
  namespace: metallb-system
spec:
  addresses:
  - 192.168.228.180-192.168.228.189
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: empty
  namespace: metallb-system
EOF
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
