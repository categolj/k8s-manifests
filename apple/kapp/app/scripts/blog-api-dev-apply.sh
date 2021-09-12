#!/bin/bash
set -ex -o pipefail
kubectl apply -f $(dirname $0)/../blog-api-dev.yaml
kubectl get app -n kapp blog-api-dev -o template='{{.status.deploy.stdout}}' -w