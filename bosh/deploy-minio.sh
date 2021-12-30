#!/bin/bash
set -ex

DIR=$(dirname $0)

${DIR}/../decrypt.sh ${DIR}/minio-creds.sops.yml
${DIR}/../decrypt.sh ${DIR}/minio-values.sops.yml

bosh create-env ${DIR}/minio.yml \
     -o ${DIR}/vsphere.yml \
     -l ${DIR}/minio-values.yml \
     --var-file=pre-start-script=${DIR}/minio-pre-start.sh  \
     --vars-store ${DIR}/minio-creds.yml \
     --var-file minio_ssh.public_key=${HOME}/.ssh/id_rsa.pub \
     --recreate

${DIR}/../encrypt.sh ${DIR}/minio-creds.yml
${DIR}/../encrypt.sh ${DIR}/minio-values.yml

#git checkout HEAD ${DIR}/minio-creds.sops.yml ${DIR}/minio-values.sops.yml