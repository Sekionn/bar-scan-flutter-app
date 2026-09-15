#!/usr/bin/env bash
set -euo pipefail

# Deploys this Flutter app to one physically connected iPhone from a Mac.
# Intended for a self-hosted macOS runner or a local terminal on the Mac that has
# Xcode, Flutter, CocoaPods, signing certificates, and the target iPhone trusted.

DEVICE_ID="${IOS_DEVICE_ID:-${1:-}}"
DART_DEFINE_FILE="${DART_DEFINE_FILE:-env/local.json}"
BUILD_MODE="${BUILD_MODE:-release}"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This script must run on macOS because iOS deployment requires Xcode."
  exit 1
fi

if [[ -z "$DEVICE_ID" ]]; then
  echo "IOS_DEVICE_ID is required."
  echo "Run 'flutter devices' on the Mac, copy the iPhone device id, then run:"
  echo "IOS_DEVICE_ID=<device-id> ./scripts/deploy_ios_device.sh"
  exit 1
fi

if [[ ! -f "$DART_DEFINE_FILE" ]]; then
  echo "Dart define file not found: $DART_DEFINE_FILE"
  exit 1
fi

if ! command -v flutter >/dev/null 2>&1; then
  echo "flutter was not found on PATH. Add Flutter to PATH on the Mac first."
  exit 1
fi

if ! command -v xcodebuild >/dev/null 2>&1; then
  echo "xcodebuild was not found. Install/select Xcode first."
  exit 1
fi

echo "Using Xcode: $(xcodebuild -version | tr '\n' ' ')"
echo "Using Flutter: $(flutter --version | head -n 1)"
echo "Target iPhone: $DEVICE_ID"
echo "Build mode: $BUILD_MODE"
echo "Dart defines: $DART_DEFINE_FILE"

flutter pub get
flutter clean
flutter run \
  -d "$DEVICE_ID" \
  --"$BUILD_MODE" \
  --dart-define-from-file="$DART_DEFINE_FILE"
