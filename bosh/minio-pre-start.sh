########## Install CLI from internet
export INSTALLATION=/var/vcap/store/installation
mkdir -p ${INSTALLATION}/bin ${INSTALLATION}/rec
cat <<'EOF' > /etc/profile.d/00-installation.sh
export INSTALLATION=/var/vcap/store/installation
export PATH=${PATH}:${INSTALLATION}/bin
EOF

MINIO_VERSION=RELEASE.2021-12-29T06-49-06Z
if [ ! -f ${INSTALLATION}/rec/minio-${MINIO_VERSION} ];then
  wget -O- https://dl.min.io/server/minio/release/linux-amd64/minio.RELEASE.2021-12-29T06-49-06Z > /tmp/minio
  mv /tmp/minio ${INSTALLATION}/bin/minio
  chmod +x ${INSTALLATION}/bin/minio
  setcap cap_net_bind_service=+ep ${INSTALLATION}/bin/minio
  touch ${INSTALLATION}/rec/minio-${MINIO_VERSION}
fi

rm -f /usr/local/bin/minio
ln -s ${INSTALLATION}/bin/minio /usr/local/bin/minio

if [ ! -d /var/vcap/store/minio ];then
  mkdir -p /var/vcap/store/minio
  chown -R minio:minio /var/vcap/store/minio
  chmod u+rxw /var/vcap/store/minio
fi

cat <<'EOF' > /etc/systemd/system/minio.service
[Unit]
Description=MinIO
Documentation=https://docs.min.io
After=network.target

[Service]
User=minio
Group=minio
ProtectProc=invisible
Restart=always
RestartSec=1
StartLimitInterval=0
EnvironmentFile=/etc/default/minio
ExecStart=/usr/local/bin/minio server $MINIO_OPTS $MINIO_VOLUMES
LimitNOFILE=1048576
TasksMax=infinity
TimeoutStopSec=infinity
SendSIGKILL=no
StandardOutput=file:/tmp/minio.log
StandardError=file:/tmp/minio.log
[Install]
WantedBy=multi-user.target
EOF

if [ ! -d /var/vcap/store/certs ];then
  mkdir -p /var/vcap/store/certs
  chown -R minio:minio /var/vcap/store/certs
  chmod u+rxw /var/vcap/store/certs
fi