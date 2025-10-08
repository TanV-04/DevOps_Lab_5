#!/bin/bash

# Jenkins Distributed Pipeline Cleanup Script
# This script stops and cleans up the Jenkins infrastructure

set -e

echo "=== Jenkins Distributed Pipeline Cleanup ==="

cd "$(dirname "$0")/../docker" || exit 1

echo "🛑 Stopping Jenkins services..."
docker-compose down

echo "🗑️  Removing containers..."
docker-compose rm -f

echo "Cleanup options:"
echo "1. Keep data volumes (recommended for development)"
echo "2. Remove data volumes (complete cleanup - WARNING: all data will be lost!)"
echo "3. Remove everything including images"
echo ""
read -p "Choose option (1-3): " -n 1 -r choice
echo

case $choice in
    1)
        echo "✅ Services stopped, data volumes preserved"
        echo "To restart: run setup.sh again"
        ;;
    2)
        echo "🗑️  Removing data volumes..."
        docker-compose down -v
        docker volume prune -f
        echo "⚠️  All Jenkins data has been removed!"
        echo "To restart: run setup.sh again (will be fresh installation)"
        ;;
    3)
        echo "🗑️  Removing everything..."
        docker-compose down -v --rmi all
        docker volume prune -f
        docker image prune -a -f
        echo "⚠️  Everything removed including Docker images!"
        echo "To restart: run setup.sh again (will rebuild images)"
        ;;
    *)
        echo "Invalid choice. Only stopped services."
        ;;
esac

echo ""
echo "Jenkins infrastructure cleanup completed."
