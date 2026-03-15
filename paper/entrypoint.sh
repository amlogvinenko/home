#!/usr/bin/env bash
set -euo pipefail

cd /srv/paper

# Paper 1.16.5 patching does not support modern Java during patch phase.
# If cached patched jar already exists in persistent storage, reuse it.
if [[ "${PAPER_VERSION:-1.16.5}" == "1.16.5" && -f cache/patched_1.16.5.jar ]]; then
  cp -f cache/patched_1.16.5.jar paper.jar
elif [[ ! -f paper.jar ]]; then
  /opt/bootstrap/download-paper.sh paper.jar
fi

touch eula.txt
if grep -q '^eula=' eula.txt; then
  sed -i 's/^eula=.*/eula=true/' eula.txt
else
  echo 'eula=true' >> eula.txt
fi

touch server.properties
set_prop() {
  local key="$1"
  local value="$2"
  if grep -q "^${key}=" server.properties; then
    sed -i "s|^${key}=.*|${key}=${value}|" server.properties
  else
    echo "${key}=${value}" >> server.properties
  fi
}

set_prop "motd" "${BACKEND_MOTD:-backend сервер happy_end_always}"
set_prop "online-mode" "false"
set_prop "query.port" "25570"
set_prop "server-port" "25570"
set_prop "enable-query" "true"

exec java -Xms"${PAPER_MIN_RAM:-512M}" -Xmx"${PAPER_MAX_RAM:-1G}" -jar paper.jar --nogui

