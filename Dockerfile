#build-stage
FROM node:lts-buster-slim as build-stage
WORKDIR /app
COPY package*.json ./
RUN npm i --production
COPY . .
RUN npm run build

#production-stage
FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
COPY ./nginx/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
