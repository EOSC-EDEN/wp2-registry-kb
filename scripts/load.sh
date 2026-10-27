#!/usr/bin/env bash
# Load the KB into Fuseki: the kb/ files into eden://kb/definitions and every
# other file into a graph named after its path. Each PUT replaces its graph.
# Requires FUSEKI_URL (the dataset URL, such as http://localhost:3030/eden),
# FUSEKI_USERNAME and FUSEKI_PASSWORD.
set -euo pipefail
shopt -s nullglob
cd "$(dirname "$0")/.."
: "${FUSEKI_URL:?}" "${FUSEKI_USERNAME:?}" "${FUSEKI_PASSWORD:?}"

put() {
  # The retries wait for Fuseki when the loader starts together with it.
  curl -fsS --retry 10 --retry-delay 3 --retry-connrefused -o /dev/null -X PUT \
    -u "$FUSEKI_USERNAME:$FUSEKI_PASSWORD" -H 'Content-Type: text/turtle' \
    --data-binary @- --url-query "graph=$1" "$FUSEKI_URL/data"
  echo "Loaded $1"
}

cat kb/*.ttl kb/profiles/*.ttl | put eden://kb/definitions
for file in memberships/*.ttl vocabs/*.ttl; do
  put "eden://kb/${file%.ttl}" < "$file"
done
