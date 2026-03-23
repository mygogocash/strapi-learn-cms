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
# Cloud Run sets PORT (default 8080); Strapi reads PORT in config/server.ts
ENV PORT=8080

EXPOSE 8080

CMD ["npm", "run", "start"]
