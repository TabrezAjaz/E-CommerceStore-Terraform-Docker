FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --omit=dev && npm cache clean --force
COPY . .
ENV NODE_ENV=production PORT=3004
EXPOSE 3004
HEALTHCHECK --interval=20s --timeout=3s --retries=5 CMD wget -qO- http://127.0.0.1:3004/health || exit 1
USER node
CMD ["node", "server.js"]
