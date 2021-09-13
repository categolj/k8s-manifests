#!/bin/bash
set -ex -o pipefail
kubectl apply -f $(dirname $0)/../opentelemetry-collector.yaml
kubectl get app -n kapp opentelemetry-collector -o template='{{.status.deploy.stdout}}' -w