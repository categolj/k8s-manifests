#!/bin/bash
set -ex -o pipefail
kubectl apply -f $(dirname $0)/../blog-counter.yaml
kubectl get app -n kapp blog-counter -o template='{{.status.deploy.stdout}}' -w