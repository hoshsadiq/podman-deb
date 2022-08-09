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
    curl --fail --silent --show-error \
      --request POST \
      --header "Accept: application/vnd.github+json" \
      --header "Authorization: token $GITHUB_PAT" \
      --data '{"event_type":"build-'"$app"'","client_payload":{"version":"'"$version"'"}}' \
      "https://api.github.com/repos/${github_repository}/dispatches"
  fi
done

wait
