# Use official Python base image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy requirements first to leverage Docker cache
COPY LAB_PROJ_1/requirements.txt .

# Install dependencies
RUN python -m venv venv && \
    . venv/bin/activate && \
    pip install --upgrade pip && \
    pip install -r requirements.txt

# Copy app code
COPY LAB_PROJ_1/ .

# Expose port
EXPOSE 8000

# Run the app
CMD ["sh", "-c", ". venv/bin/activate && uvicorn app:app --host 0.0.0.0 --port 8000"]
