# strapi-learn-cms

Strapi 5 CMS for **GoGoCash Learn** (`/learn` on the landing site). REST collection: **`learn-articles`**.

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

See the landing repo runbook (same machine):  
`../Landing page/docs/strapi-gcp-runbook.md`

Quick image build with Cloud Build:

```bash
gcloud config set project gogocash-cms
gcloud builds submit --config=cloudbuild.yaml
```

Docker locally:

```bash
docker build -t strapi-learn-cms:local .
```

## Landing site integration

Set `STRAPI_URL` (and `STRAPI_API_TOKEN` if the API is private) when running `next build` on the Firebase landing. Optional: `npm run learn:strapi-push` from the landing repo to seed from `content/learn/*.md`.
