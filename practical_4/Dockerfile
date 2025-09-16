FROM node:18

# Set working directory
WORKDIR /usr/src/app

# Copy dependency files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy app files
COPY . .

# Expose app port
EXPOSE 5000

# Start app
CMD ["npm", "start"]
