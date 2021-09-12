#!/bin/bash
set -ex -o pipefail
kubectl apply -f $(dirname $0)/../blog-feed.yaml
kubectl get app -n kapp blog-feed -o template='{{.status.deploy.stdout}}' -w