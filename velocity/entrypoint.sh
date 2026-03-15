#!/usr/bin/env bash
set -euo pipefail

cd /srv/velocity

if [[ ! -f velocity.jar ]]; then
  /opt/bootstrap/download-velocity.sh velocity.jar
fi

cp /opt/bootstrap/velocity.toml.template /tmp/velocity.toml
sed -i "s|\${VELOCITY_BIND}|${VELOCITY_BIND:-0.0.0.0:25565}|g" /tmp/velocity.toml
sed -i "s|\${VELOCITY_BACKEND}|${VELOCITY_BACKEND:-paper:25570}|g" /tmp/velocity.toml
mv /tmp/velocity.toml velocity.toml

exec java -Xms256M -Xmx512M -jar velocity.jar
