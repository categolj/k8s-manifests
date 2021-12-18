#!/bin/bash
set -ex

DIR=$(dirname $0)

${DIR}/../decrypt.sh ${DIR}/jumpbox-creds.sops.yml
${DIR}/../decrypt.sh ${DIR}/jumpbox-values.sops.yml

bosh create-env ${DIR}/jumpbox.yml \
     -o ${DIR}/vsphere.yml \
     -l ${DIR}/jumpbox-values.yml \
     --var-file=pre-start-script=${DIR}/pre-start.sh  \
     --vars-store ${DIR}/jumpbox-creds.yml \
     --var-file jumpbox_ssh.public_key=${HOME}/.ssh/id_rsa.pub --recreate

${DIR}/../encrypt.sh ${DIR}/jumpbox-creds.yml
${DIR}/../encrypt.sh ${DIR}/jumpbox-values.yml

git checkout HEAD ${DIR}/jumpbox-creds.sops.yml ${DIR}/jumpbox-values.sops.yml