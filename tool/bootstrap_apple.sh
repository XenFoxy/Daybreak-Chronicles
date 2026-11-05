#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
if [[ -d ios && -d macos ]]; then
  exit 0
fi

scaffold="$(mktemp -d)"
trap 'rm -rf "$scaffold"' EXIT
flutter create --no-pub --platforms=ios,macos --org io.github.xenfoxy \
  --project-name daybreak_chronicles "$scaffold/daybreak_chronicles"

for platform in ios macos; do
  if [[ ! -e "$platform" ]]; then
    cp -R "$scaffold/daybreak_chronicles/$platform" "$platform"
  fi
done
