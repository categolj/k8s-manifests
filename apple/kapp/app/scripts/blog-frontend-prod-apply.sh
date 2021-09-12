#!/bin/bash
set -ex -o pipefail
kubectl apply -f $(dirname $0)/../blog-frontend-prod.yaml
kubectl get app -n kapp blog-frontend-prod -o template='{{.status.deploy.stdout}}' -w