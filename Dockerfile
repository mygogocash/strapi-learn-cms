# Production image for Google Cloud Run (Strapi 5 + PostgreSQL)
FROM node:20-bookworm-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
  python3 \
  build-essential \
  && rm -rf /var/lib/apt/lists/*

COPY package.json package-lock.json ./
RUN npm ci

COPY . .

ENV NODE_ENV=production
RUN npm run build && npm prune --omit=dev

ENV HOST=0.0.0.0

EXPOSE 1337

CMD ["npm", "run", "start"]
