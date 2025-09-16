# Use official Node.js runtime as base
FROM node:18

# Set working directory
WORKDIR /usr/src/app

# Copy package files first (better caching)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy rest of the app
COPY . .

# Expose port
EXPOSE 8080

# Start app
CMD ["npm", "start"]
