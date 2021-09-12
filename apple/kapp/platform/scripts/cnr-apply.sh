#!/bin/bash
set -ex -o pipefail
kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: cloud-native-runtimes
EOF
kubectl apply -n cloud-native-runtimes -f $(dirname $0)/../cnr.yaml -f $(dirname $0)/../cnr-config.yaml
kubectl get app -n cloud-native-runtimes cloud-native-runtimes -o template='{{.status.deploy.stdout}}' -w