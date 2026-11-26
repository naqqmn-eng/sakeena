#!/usr/bin/env bash
# Prepares the Android build once per checkout.
#
# The Gradle wrapper descriptor ships as `gradle-wrapper.properties.example`
# so the pinned distribution URL is visible in review before it is enabled.
# Gradle itself only reads `gradle-wrapper.properties`, so this script copies
# it into place. It is idempotent: an existing file is never overwritten.
#
# Usage: bash scripts/setup-android.sh

set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
wrapper_dir="$root_dir/android/gradle/wrapper"

if [[ -f "$wrapper_dir/gradle-wrapper.properties" ]]; then
    echo "gradle-wrapper.properties already present — nothing to do."
    exit 0
fi

cp "$wrapper_dir/gradle-wrapper.properties.example" \
   "$wrapper_dir/gradle-wrapper.properties"
echo "Created android/gradle/wrapper/gradle-wrapper.properties (Gradle 8.10.2)."
