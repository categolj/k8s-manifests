#!/bin/bash
set -ex -o pipefail
kubectl apply -f $(dirname $0)/../secretgen-controller.yaml
kubectl get app -n kapp secretgen-controller -o template='{{.status.deploy.stdout}}' -w