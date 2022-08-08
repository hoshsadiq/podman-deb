#!/usr/bin/env bash

set -euo pipefail

github_repository="$1"
shift

repositories=()
if [ "$#" -gt 0 ]; then
  repositories=("$@")
else
  mapfile -d $'\0' repositories < <(find .github/workflows -name "build-*.yml" -exec bash -euc 'filename="$(basename $1 .yml)"; printf "%s\0" "${filename//build-}"' _ {} \;)
fi

for app in "${repositories[@]}"; do
  version="$(./scripts/is_updated.sh "$app" "${github_repository}")"
  if [ -n "$version" ]; then
    curl \
      -X POST \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: token $GITHUB_PAT" \
      "https://api.github.com/repos/${github_repository}/dispatches" \
      -d '{"event_type":"build-'"$app"'","client_payload":{"version":"'"$version"'"}}' &
  fi
done

wait
