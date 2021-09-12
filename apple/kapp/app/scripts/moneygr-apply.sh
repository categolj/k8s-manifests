#!/bin/bash
set -ex -o pipefail
kubectl apply -f $(dirname $0)/../moneygr.yaml
kubectl get app -n kapp moneygr -o template='{{.status.deploy.stdout}}' -w