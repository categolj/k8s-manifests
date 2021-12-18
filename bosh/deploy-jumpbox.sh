#!/bin/bash
set -ex

DIR=$(dirname $0)

bosh create-env ${DIR}/jumpbox.yml \
     -o ${DIR}/vsphere.yml \
     -l ${DIR}/jumpbox-values.yml \
     --var-file=pre-start-script=${DIR}/pre-start.sh  \
     --vars-store ${DIR}/jumpbox-creds.yml \
     --var-file jumpbox_ssh.public_key=${HOME}/.ssh/id_rsa.pub --recreate