# Using the Python base image
FROM python:3.10-slim
LABEL authors="a.jalilian66@gmail.com"

# Setting environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/core

# Taking environment variable as argument
ARG DJANGO_ENVIRONMENT=development
ENV DJANGO_ENVIRONMENT=${DJANGO_ENVIRONMENT}

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    netcat-openbsd \
    dos2unix \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /core

# Copy requirements files
COPY ./requirements /requirements

# Install dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r /requirements/base.txt && \
    pip install --no-cache-dir -r /requirements/${DJANGO_ENVIRONMENT}.txt

# Copy scripts first
COPY ./scripts /scripts

# Convert script to Unix format and make it executable
RUN dos2unix /scripts/entrypoint.sh && \
    chmod +x /scripts/entrypoint.sh && \
    ls -la /scripts/

# Add scripts to PATH
ENV PATH="/scripts:$PATH"

# Copy project files
COPY ./core /core

# Expose port
EXPOSE 8000

# Use full path and bash to execute the script
CMD ["/bin/bash", "/scripts/entrypoint.sh"]