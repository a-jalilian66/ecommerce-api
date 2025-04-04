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

# Copy scripts first and fix permissions
COPY ./scripts /scripts
# Convert to Unix line endings (in case of Windows CRLF)
RUN dos2unix /scripts/entrypoint.sh
# Make script executable with proper permissions
RUN chmod +x /scripts/entrypoint.sh
# Set full access for scripts directory
RUN chmod -R 755 /scripts

# Add scripts to PATH
ENV PATH="/scripts:$PATH"

# Copy project files
COPY ./core /core

# Create non-root user for security
RUN addgroup --system app && adduser --system --group app

# Change ownership AFTER setting permissions
RUN chown -R app:app /core
RUN chown -R app:app /scripts

# Switch to non-root user
USER app

# Expose port
EXPOSE 8000

# Run entrypoint script with bash for better error handling
CMD ["bash", "/scripts/entrypoint.sh"]