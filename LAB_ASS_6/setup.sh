#!/bin/bash

# Setup script for kind cluster and ping server

set -e

echo "🔍 Checking prerequisites..."

# Check if kind is installed
if ! command -v kind &> /dev/null; then
    echo "❌ kind is not installed. Please install it first:"
    echo "   On macOS: brew install kind"
    echo "   Or follow: https://kind.sigs.k8s.io/docs/user/quick-start/#installation"
    exit 1
fi

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl is not installed. Please install it first:"
    echo "   On macOS: brew install kubectl"
    exit 1
fi

# Check if docker is running
if ! docker info &> /dev/null; then
    echo "❌ Docker is not running. Please start Docker Desktop."
    exit 1
fi

echo "✅ All prerequisites are met!"

# Install npm dependencies
echo "📦 Installing npm dependencies..."
npm install

echo "🎉 Setup complete! You can now run:"
echo "   ./deploy.sh  # to build and deploy the ping server"
echo "   npm start    # to run locally for development"
