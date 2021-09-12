#!/bin/bash
set -ex -o pipefail
kubectl apply -f $(dirname $0)/../blog-api-prod.yaml
kubectl get app -n kapp blog-api-prod -o template='{{.status.deploy.stdout}}' -w