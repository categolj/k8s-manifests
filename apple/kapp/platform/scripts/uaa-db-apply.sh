#!/bin/bash
set -ex -o pipefail
kubectl apply -f $(dirname $0)/../uaa-db.yaml
kubectl get app -n kapp uaa-db -o template='{{.status.deploy.stdout}}' -w