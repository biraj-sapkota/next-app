FROM node:latest AS buildStage
WORKDIR /src

COPY package*.json .
RUN npm install

COPY . .
RUN npm run build

FROM node:latest AS productionStage
WORKDIR /app

COPY --from=buildStage /src/node_modules/ ./node_modules
COPY --from=buildStage /src/public/ ./public
COPY --from=buildStage /src/package*.json .
COPY --from=buildStage /src/.next/ ./.next

EXPOSE 3000
CMD [ "npm", "start" ]