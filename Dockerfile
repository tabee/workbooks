# Use Python 3.11 slim image as base
FROM python:3.11-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Set working directory
WORKDIR /docs

# Copy requirements file
COPY requirements.txt /tmp/requirements.txt

# Install MkDocs and popular plugins for multi-project documentation
RUN pip install --no-cache-dir -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt

# Expose MkDocs default port
EXPOSE 8000

# Set default command to serve MkDocs
CMD ["mkdocs", "serve", "--dev-addr=0.0.0.0:8000"]
