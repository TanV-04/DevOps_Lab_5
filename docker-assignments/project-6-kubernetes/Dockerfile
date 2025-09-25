# Use Python base image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy requirements
COPY requirements.txt requirements.txt

# Install dependencies
RUN pip install -r requirements.txt

# Copy app
COPY app.py app.py

# Expose port
EXPOSE 5000

# Run app
CMD ["python", "app.py"]
