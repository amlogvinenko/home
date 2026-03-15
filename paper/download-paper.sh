#!/usr/bin/env bash
set -euo pipefail

PAPER_VERSION="${PAPER_VERSION:-1.16.5}"
OUT_JAR="${1:-paper.jar}"

API_BASE="https://api.papermc.io/v2/projects/paper/versions/${PAPER_VERSION}"
BUILDS_JSON="$(curl -fsSL "${API_BASE}/builds")"
LATEST_BUILD="$(echo "${BUILDS_JSON}" | jq -r '[.builds[] | select(.channel == "default") | .build] | max')"

if [[ -z "${LATEST_BUILD}" || "${LATEST_BUILD}" == "null" ]]; then
  echo "Failed to resolve latest Paper build for version ${PAPER_VERSION}" >&2
  exit 1
fi

JAR_NAME="$(echo "${BUILDS_JSON}" | jq -r --argjson b "${LATEST_BUILD}" '.builds[] | select(.build == $b) | .downloads.application.name')"
if [[ -z "${JAR_NAME}" || "${JAR_NAME}" == "null" ]]; then
  echo "Failed to resolve Paper jar name for build ${LATEST_BUILD}" >&2
  exit 1
fi

DOWNLOAD_URL="${API_BASE}/builds/${LATEST_BUILD}/downloads/${JAR_NAME}"
echo "Downloading Paper ${PAPER_VERSION} build ${LATEST_BUILD}..."
curl -fsSL "${DOWNLOAD_URL}" -o "${OUT_JAR}"
