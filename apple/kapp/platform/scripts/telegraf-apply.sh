#!/bin/bash
set -ex -o pipefail
kubectl apply -f $(dirname $0)/../telegraf.yaml
kubectl get app -n kapp telegraf -o template='{{.status.deploy.stdout}}' -w