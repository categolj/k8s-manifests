#!/bin/bash
set -ex -o pipefail
kubectl apply -f $(dirname $0)/../uaa.yaml
kubectl get app -n kapp uaa -o template='{{.status.deploy.stdout}}' -w