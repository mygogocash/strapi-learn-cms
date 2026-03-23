#!/usr/bin/env bash
# Build and deploy Strapi to Cloud Run using Cloud Build.
# Usage:
#   export CLOUDSQL_CONNECTION_NAME="gogocash-cms:asia-southeast1:YOUR_INSTANCE"
#   ./scripts/deploy-production.sh
#
# Requires: gcloud authenticated, project gogocash-cms, secrets + IAM per README / runbook.

set -euo pipefail

PROJECT_ID="${GCP_PROJECT_ID:-gogocash-cms}"
REGION="${GCP_REGION:-asia-southeast1}"
SQL_INSTANCE="${CLOUDSQL_CONNECTION_NAME:-}"

if [[ -z "$SQL_INSTANCE" ]]; then
  echo "Set CLOUDSQL_CONNECTION_NAME (e.g. gogocash-cms:asia-southeast1:my-db)" >&2
  exit 1
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

gcloud config set project "$PROJECT_ID"
gcloud builds submit \
  --project="$PROJECT_ID" \
  --config=cloudbuild.deploy.yaml \
  --substitutions="_REGION=$REGION,_SQL_INSTANCE=$SQL_INSTANCE"

echo "Done. Service URL:"
gcloud run services describe strapi --project="$PROJECT_ID" --region="$REGION" --format='value(status.url)'
