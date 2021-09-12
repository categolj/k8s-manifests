#!/bin/bash
set -ex -o pipefail
kubectl apply -f $(dirname $0)/../note.yaml
kubectl get app -n kapp note -o template='{{.status.deploy.stdout}}' -w