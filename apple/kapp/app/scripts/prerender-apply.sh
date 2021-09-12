#!/bin/bash
set -ex -o pipefail
kubectl apply -f $(dirname $0)/../prerender.yaml
kubectl get app -n kapp prerender -o template='{{.status.deploy.stdout}}' -w