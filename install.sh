#!/usr/bin/env bash
# Install LaunchAgent that removes the macOS Caps Lock activation delay at login.
set -euo pipefail

LABEL="com.user.capslocknodelay"
SRC_PLIST="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/${LABEL}.plist"
DEST_DIR="${HOME}/Library/LaunchAgents"
DEST_PLIST="${DEST_DIR}/${LABEL}.plist"

if [[ ! -f "${SRC_PLIST}" ]]; then
    echo "error: plist not found at ${SRC_PLIST}" >&2
    exit 1
fi

mkdir -p "${DEST_DIR}"
cp "${SRC_PLIST}" "${DEST_PLIST}"
chmod 644 "${DEST_PLIST}"

UID_NUM="$(id -u)"
DOMAIN="gui/${UID_NUM}"
SERVICE="${DOMAIN}/${LABEL}"

if launchctl print "${SERVICE}" >/dev/null 2>&1; then
    launchctl bootout "${SERVICE}" || true
fi

launchctl bootstrap "${DOMAIN}" "${DEST_PLIST}"
launchctl kickstart "${SERVICE}" >/dev/null

sleep 1
CURRENT="$(hidutil property --get CapsLockDelayOverride 2>/dev/null || echo '(null)')"
echo "installed: ${DEST_PLIST}"
echo "hidutil CapsLockDelayOverride = ${CURRENT}"

if [[ "${CURRENT}" != *"0"* ]]; then
    echo "warn: override not applied; check /tmp/capslocknodelay.err" >&2
    exit 1
fi
