#!/bin/bash
set -ex -o pipefail
kubectl apply -f $(dirname $0)/../coredns.yaml
kubectl get app -n kapp coredns -o template='{{.status.deploy.stdout}}' -w