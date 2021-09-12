#!/bin/bash
set -ex -o pipefail
kubectl apply -f $(dirname $0)/../metallb.yaml
kubectl get app -n kapp metallb -o template='{{.status.deploy.stdout}}' -w