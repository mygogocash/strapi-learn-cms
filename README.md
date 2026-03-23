# strapi-learn-cms

Strapi 5 CMS for **GoGoCash Learn** (`/learn` on the landing site). REST collection: **`learn-articles`**.

**Repository:** [github.com/mygogocash/strapi-learn-cms](https://github.com/mygogocash/strapi-learn-cms)

## Local development

```bash
cp .env.example .env
# Fill APP_KEYS, salts, and secrets (see Strapi docs). SQLite works by default.
npm install
npm run develop
```

Admin: `http://localhost:1337/admin`

## Content type

**Learn Article** (`learn-articles`): `slug` (UID), `title`, `metaTitle`, `metaDescription`, `hubDesc`, `content` (Markdown as plain text). Draft & publish enabled.

After first deploy, enable **Public** `find` + `findOne` on `learn-article` *or* use API tokens from the landing build.

## Production on GCP

Full checklist (secrets, Cloud SQL, IAM): **[landing-page `docs/strapi-gcp-runbook.md`](https://github.com/mygogocash/landing-page/blob/main/docs/strapi-gcp-runbook.md)**.

### Build image only (no deploy)

```bash
gcloud config set project gogocash-cms
gcloud builds submit --config=cloudbuild.yaml
```

### Build + deploy to Cloud Run (one command)

Set your Cloud SQL **connection name** (`project:region:instance`), then:

```bash
export CLOUDSQL_CONNECTION_NAME="gogocash-cms:asia-southeast1:YOUR_INSTANCE"
./scripts/deploy-production.sh
```

Or with explicit substitutions:

```bash
gcloud builds submit --project=gogocash-cms --config=cloudbuild.deploy.yaml \
  --substitutions=_SQL_INSTANCE=gogocash-cms:asia-southeast1:YOUR_INSTANCE
```

The container listens on **port 8080** (Cloud Run default).

### GitHub Actions

Workflow **[`.github/workflows/deploy-gcp.yml`](.github/workflows/deploy-gcp.yml)** runs on every push to `main` (and manual **Run workflow**).

**One-time setup**

1. GCP: create a **service account** with **Cloud Build Editor** (or roles to run `gcloud builds submit`).
2. Grant **Cloud Build’s** service account (`PROJECT_NUMBER@cloudbuild.gserviceaccount.com`) **Cloud Run Admin** and **Service Account User** on the **Compute default** service account used by Cloud Run (see runbook).
3. GitHub → repo **Secrets**: `GCP_SA_KEY` = SA JSON key.
4. GitHub → repo **Variables**: `GCP_CLOUDSQL_CONNECTION_NAME` = `gogocash-cms:REGION:INSTANCE`.

Until `GCP_SA_KEY` and `GCP_CLOUDSQL_CONNECTION_NAME` are set, the workflow will fail (by design).

### Docker (local image)

```bash
docker build -t strapi-learn-cms:local .
```

## Landing site integration

Set `STRAPI_URL` (and `STRAPI_API_TOKEN` if the API is private) when running `next build` on the Firebase landing. Optional: `npm run learn:strapi-push` from the landing repo to seed from `content/learn/*.md`.
