#!/usr/bin/env bash

set -euo pipefail

app="$1"
current_repo="$2"
get_latest="${3:-false}"

# shellcheck source=podman/.env
source "./$app/.env"

tag_prefix="${app}-"
upstream_tag="$(git ls-remote --tags "https://github.com/${repo:?}" | awk -F/ '$3 ~ /^v?[0-9]+(\.[0-9]+){1,2}$/{gsub(/^v/, "", $3); print $3}' | sort --version-sort --reverse | head -n1)"
latest_tag="$(git ls-remote --tags "https://github.com/$current_repo" | awk -F/ '$3 ~ /^'"$tag_prefix"'[0-9]+(\.[0-9]+){2}$/{gsub(/^'"$tag_prefix"'/, "", $3); print $3}' | sort --version-sort --reverse | head -n1)"

if [ "$get_latest" = "true" ] || [ "$upstream_tag" != "$latest_tag" ]; then
  printf "%s" "$upstream_tag"
fi
