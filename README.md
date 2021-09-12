# k8s-manifests

Set up a cluster for GitOps

```
kubectl create ns kapp
kubectl create -n kapp sa kapp
kubectl create clusterrolebinding kapp-cluster-admin --clusterrole cluster-admin --serviceaccount=kapp:kapp
kubectl create secret generic -n kapp github --from-file=ssh-privatekey=$HOME/.ssh/kapp-controller --dry-run=client -oyaml | kubectl apply -f-
kubectl create secret generic -n kapp pgp-key --from-file=$HOME/.gnupg/my.pk --dry-run=client -oyaml | kubectl apply -f-
```

## How to generate GPG keys 

https://carvel.dev/kapp-controller/docs/latest/sops/

```
mkdir -p $HOME/.gnupg
cat <<EOF > $HOME/.gnupg/conf
%no-protection
Key-Type: 1
Key-Length: 4096
Subkey-Type: 1
Subkey-Length: 4096
Expire-Date: 0
Name-Comment: kapp-controller-sops
Name-Real: Toshiaki Maki
Name-Email: makingx@gmail.com
EOF
docker run --rm -v $HOME/.gnupg:/root/.gnupg --entrypoint gpg maven:3.8.2 --batch --full-generate-key /root/.gnupg/conf
docker run --rm -v $HOME/.gnupg:/root/.gnupg --entrypoint gpg maven:3.8.2 --list-secret-keys "Toshiaki Maki"
docker run --rm -v $HOME/.gnupg:/root/.gnupg --entrypoint gpg maven:3.8.2 --armor --export-secret-keys AB2978B9059B0ACD > $HOME/.gnupg/my.pk
```