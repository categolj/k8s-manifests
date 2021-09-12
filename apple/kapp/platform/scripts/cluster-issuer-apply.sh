#!/bin/bash
set -ex -o pipefail
kubectl apply -f $(dirname $0)/../cluster-issuer.yaml
kubectl get app -n kapp cluster-issuer -o template='{{.status.deploy.stdout}}' -w