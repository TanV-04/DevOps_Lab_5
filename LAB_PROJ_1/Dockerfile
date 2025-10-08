# Use official Python image as base
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy requirements and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app code
COPY app.py .

# Expose port
EXPOSE 8000

# Command to run the API
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
