# syntax=docker/dockerfile:1

###########
# 1. Build stage
###########
FROM node:20-alpine AS build

WORKDIR /usr/src/app

# Copy package files from the Angular app directory
COPY test/package*.json ./
RUN npm ci

# Copy the Angular application source
COPY test/ .
# You can pass build args: --build-arg CONFIG=production
ARG CONFIG=production
RUN npm run build -- --configuration=$CONFIG

###########
# 2. Serve stage
###########
FROM nginx:1.27-alpine

# Remove default nginx site
RUN rm -rf /usr/share/nginx/html/*

# Copy dist from build stage (Angular apps typically output to dist/project-name)
COPY --from=build /usr/src/app/dist/test/ /usr/share/nginx/html/

# Custom nginx config (handles SPA fallback to index.html)
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
