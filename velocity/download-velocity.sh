#!/usr/bin/env bash
set -euo pipefail

OUT_JAR="${1:-velocity.jar}"
API_BASE="https://api.papermc.io/v2/projects/velocity"

VERSIONS_JSON="$(curl -fsSL "${API_BASE}")"
LATEST_VERSION="$(echo "${VERSIONS_JSON}" | jq -r '.versions[-1]')"
if [[ -z "${LATEST_VERSION}" || "${LATEST_VERSION}" == "null" ]]; then
  echo "Failed to resolve Velocity version" >&2
  exit 1
fi

BUILDS_JSON="$(curl -fsSL "${API_BASE}/versions/${LATEST_VERSION}/builds")"
LATEST_BUILD="$(echo "${BUILDS_JSON}" | jq -r '[.builds[] | select(.channel == "default") | .build] | max')"
if [[ -z "${LATEST_BUILD}" || "${LATEST_BUILD}" == "null" ]]; then
  echo "Failed to resolve Velocity build for ${LATEST_VERSION}" >&2
  exit 1
fi

JAR_NAME="$(echo "${BUILDS_JSON}" | jq -r --argjson b "${LATEST_BUILD}" '.builds[] | select(.build == $b) | .downloads.application.name')"
if [[ -z "${JAR_NAME}" || "${JAR_NAME}" == "null" ]]; then
  echo "Failed to resolve Velocity jar name for build ${LATEST_BUILD}" >&2
  exit 1
fi

DOWNLOAD_URL="${API_BASE}/versions/${LATEST_VERSION}/builds/${LATEST_BUILD}/downloads/${JAR_NAME}"
echo "Downloading Velocity ${LATEST_VERSION} build ${LATEST_BUILD}..."
curl -fsSL "${DOWNLOAD_URL}" -o "${OUT_JAR}"
