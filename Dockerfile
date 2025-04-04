# Using the Python base image
FROM python:3.10-slim
LABEL authors="a.jalilian66@gmail.com"

# Setting environment variables
ENV PYTHONDONTWRITEBYTECODE=1  # Prevents Python from writing .pyc files
ENV PYTHONUNBUFFERED=1         # Unbuffered output - better for logging
ENV PYTHONPATH=/core           # Add /core to Python path

# Create non-root user for security
RUN addgroup --system app && adduser --system --group app

# Taking environment variable as argument
ARG DJANGO_ENVIRONMENT=development
ENV DJANGO_ENVIRONMENT=${DJANGO_ENVIRONMENT}

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \       # Required for compiling some packages
    libpq-dev \             # PostgreSQL driver
    netcat-openbsd \        # To check connectivity to services
    && apt-get clean \      # Clear cache
    && rm -rf /var/lib/apt/lists/*  # Reduce image size

# Set working directory
WORKDIR /core

# Copy requirements files
COPY ./requirements /requirements

# Install dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r /requirements/base.txt && \
    pip install --no-cache-dir -r /requirements/${DJANGO_ENVIRONMENT}.txt

# Copy scripts
COPY ./scripts /scripts
RUN chmod -R +x /scripts
ENV PATH="/scripts:$PATH"

# Copy project files
COPY ./core /core

# Change ownership to non-root user
RUN chown -R app:app /core
RUN chown -R app:app /scripts

# Switch to non-root user
USER app

# Expose port
EXPOSE 8000

# Run entrypoint script
CMD ["entrypoint.sh"]