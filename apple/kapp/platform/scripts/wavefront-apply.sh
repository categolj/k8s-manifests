#!/bin/bash
set -ex -o pipefail
kubectl apply -f $(dirname $0)/../wavefront.yaml
kubectl get app -n kapp wavefront -o template='{{.status.deploy.stdout}}' -w