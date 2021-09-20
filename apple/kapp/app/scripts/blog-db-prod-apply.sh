#!/bin/bash
set -ex -o pipefail
kubectl apply -f $(dirname $0)/../blog-db-prod.yaml
kubectl get app -n kapp blog-db-prod -o template='{{.status.deploy.stdout}}' -w