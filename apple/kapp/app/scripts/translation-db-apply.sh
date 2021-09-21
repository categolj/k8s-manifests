#!/bin/bash
set -ex -o pipefail
kubectl apply -f $(dirname $0)/../translation-db.yaml
kubectl get app -n kapp translation-db -o template='{{.status.deploy.stdout}}' -w