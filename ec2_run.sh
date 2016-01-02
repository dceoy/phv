#!/usr/bin/env bash

set -uex

S3_DIR="/dev/shm/s3"
S3_BUCKET="ec2-r3"
IAM_ROLE="s3user"
SOC_CSV="output/csv/dt_soc.csv"

cd ${HOME}/phv
[[ -f ${SOC_CSV} ]] || time Rscript prep_tables.R
if mkdir ${S3_DIR}; then
  sudo /usr/local/bin/s3fs ${S3_BUCKET} ${S3_DIR} \
    -o "rw,allow_other,$(id | sed 's/^.*\(uid=[0-9]\+\).*\(gid=[0-9]\+\).*$/\1,\2/g'),iam_role=${IAM_ROLE}"
fi
time rsync -r ${HOME}/phv ${S3_DIR}
cd ${S3_DIR}/phv
sed '1d' ${SOC_CSV} | cut -f 1 -d ' ' | xargs -P $(sed '1d' ${SOC_CSV} | wc -l) -I {} time Rscript hglm.R {}
sudo poweroff
