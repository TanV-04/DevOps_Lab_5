# Use the official Node.js image as the base image
FROM node:18-alpine AS build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY angular-app/package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY angular-app/ .

# Build the Angular application for production
RUN npm run build --configuration=production

# Use Nginx to serve the built application
FROM nginx:alpine

# Copy the built application from the build stage
COPY --from=build /app/dist/angular-app/browser /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
