#!/bin/bash
set -ex -o pipefail
INPUT_FILE=$1
OUTPUT_FILE=$(echo ${INPUT_FILE} | sed 's/.yaml$/.sops.yaml/' | sed 's/.yml$/.sops.yml/')

sops --encrypt --pgp AB2978B9059B0ACD ${INPUT_FILE} > ${OUTPUT_FILE}
rm -f ${INPUT_FILE}