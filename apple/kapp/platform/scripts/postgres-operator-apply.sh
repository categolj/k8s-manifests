#!/bin/bash
set -ex -o pipefail
kubectl apply -f $(dirname $0)/../postgres-operator.yaml
kubectl get app -n kapp postgres-operator -o template='{{.status.deploy.stdout}}' -w