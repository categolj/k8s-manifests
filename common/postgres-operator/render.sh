#!/bin/zsh
set -ex
export HELM_EXPERIMENTAL_OCI=1
rm -rf /tmp/postgres-operator

helm registry login registry.pivotal.io --username=${TANZUNET_USERNAME} --password=${TANZUNET_PASSWORD}
helm chart pull registry.pivotal.io/tanzu-sql-postgres/postgres-operator-chart:v1.5.0
helm chart export registry.pivotal.io/tanzu-sql-postgres/postgres-operator-chart:v1.5.0 --destination=/tmp/
helm template -n postgres-operator --include-crds /tmp/postgres-operator > postgres-operator.yaml