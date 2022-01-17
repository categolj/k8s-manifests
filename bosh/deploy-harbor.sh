#!/bin/bash
set -ex

DIR=$(dirname $0)

${DIR}/../decrypt.sh ${DIR}/harbor-creds.sops.yml
${DIR}/../decrypt.sh ${DIR}/harbor-values.sops.yml

bosh create-env ${DIR}/harbor.yml \
     -o ${DIR}/vsphere.yml \
     -l ${DIR}/harbor-values.yml \
     --var-file=pre-start-script=${DIR}/harbor-pre-start.sh  \
     --vars-store ${DIR}/harbor-creds.yml \
     --var-file harbor_ssh.public_key=${HOME}/.ssh/id_rsa.pub \
     --recreate

${DIR}/../encrypt.sh ${DIR}/harbor-creds.yml
${DIR}/../encrypt.sh ${DIR}/harbor-values.yml

#git checkout HEAD ${DIR}/harbor-creds.sops.yml ${DIR}/harbor-values.sops.yml