FROM node:16-alpine as build

WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM node:16-alpine
WORKDIR /usr/src/app
COPY --from=build /usr/src/app/package*.json ./
RUN npm ci --only=production && npm cache clean --force
COPY --from=build /usr/src/app/dist ./dist
CMD ["node", "./dist/index.js"]
