#!/bin/zsh
export HELM_EXPERIMENTAL_OCI=1
rm -rf /tmp/postgres-operator
helm chart export registry.pivotal.io/tanzu-sql-postgres/postgres-operator-chart:v1.2.0 --destination=/tmp/
helm template -n postgres-operator --include-crds /tmp/postgres-operator > postgres-operator.yaml