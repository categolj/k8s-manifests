#!/bin/bash
set -ex -o pipefail
kubectl apply -f $(dirname $0)/../gateway.yaml
kubectl get app -n kapp gateway -o template='{{.status.deploy.stdout}}' -w