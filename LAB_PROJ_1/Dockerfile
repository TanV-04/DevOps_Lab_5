FROM python:3.11-slim

WORKDIR /app

# Install build dependencies (optional but useful)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gcc && \
    rm -rf /var/lib/apt/lists/*

# Copy requirements and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files (app.py is at repo root)
COPY . .

EXPOSE 8000

# Run Litestar app with uvicorn
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
