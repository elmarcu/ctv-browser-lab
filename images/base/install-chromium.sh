#!/usr/bin/env bash
set -e

CHROMIUM_VERSION="$1"

if [ -z "$CHROMIUM_VERSION" ]; then
  echo "CHROMIUM_VERSION is required"
  exit 1
fi

echo "Installing Chromium version ${CHROMIUM_VERSION}"

# Map major version to snapshot (simplified for v1)
SNAPSHOT_URL="https://commondatastorage.googleapis.com/chromium-browser-snapshots/Linux_x64"

# NOTE: For v1 we document known-good snapshot IDs per version.
# This avoids fragile lookups.
case "$CHROMIUM_VERSION" in
  72) SNAPSHOT_ID=612437 ;;
  80) SNAPSHOT_ID=722274 ;;
  84) SNAPSHOT_ID=756066 ;;
  90) SNAPSHOT_ID=856583 ;;
  *)
    echo "Unsupported Chromium version: $CHROMIUM_VERSION"
    exit 1
    ;;
esac

curl -sSL \
  "${SNAPSHOT_URL}/${SNAPSHOT_ID}/chrome-linux.zip" \
  -o /tmp/chromium.zip

apt-get update && apt-get install -y unzip

unzip /tmp/chromium.zip -d /opt
mv /opt/chrome-linux /opt/chromium

ln -s /opt/chromium/chrome /usr/local/bin/chromium

rm -rf /tmp/chromium.zip
echo "Chromium version ${CHROMIUM_VERSION} installed successfully"