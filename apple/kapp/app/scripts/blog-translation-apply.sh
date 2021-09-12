#!/bin/bash
set -ex -o pipefail
kubectl apply -f $(dirname $0)/../blog-translation.yaml
kubectl get app -n kapp blog-translation -o template='{{.status.deploy.stdout}}' -w