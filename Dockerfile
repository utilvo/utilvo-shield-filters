FROM node:20-alpine

LABEL org.opencontainers.image.title="utilvo-shield-filters" \
      org.opencontainers.image.description="Zero-dependency parser and domain suffix matcher for Adblock Plus 2.0 and uBlock Origin network filter rules." \
      org.opencontainers.image.url="https://utilvo.com/shield" \
      org.opencontainers.image.documentation="https://utilvo.com/shield" \
      org.opencontainers.image.source="https://github.com/utilvo/utilvo-shield-filters" \
      org.opencontainers.image.vendor="Utilvo" \
      org.opencontainers.image.licenses="MIT"

WORKDIR /app
COPY package.json index.js index.d.ts README.md LICENSE ./
COPY bin/ ./bin/

ENTRYPOINT ["node", "/app/bin/cli.js"]
CMD ["--help"]
