#!/bin/bash
set -ex -o pipefail
kubectl apply -f $(dirname $0)/../blog-frontend-dev.yaml
kubectl get app -n kapp blog-frontend-dev -o template='{{.status.deploy.stdout}}' -w