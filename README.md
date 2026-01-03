# workbooks

## Docker MkDocs Environment

This repository provides a Dockerfile to set up a complete MkDocs environment ready to document multiple projects.

### Quick Start

Build the Docker image:
```bash
docker build -t mkdocs-env .
```

Run MkDocs server:
```bash
docker run -it --rm -p 8000:8000 -v $(pwd):/docs mkdocs-env
```

### Using Makefile (Recommended)

For convenience, use the included Makefile:

```bash
make build    # Build the Docker image
make serve    # Run MkDocs server
make help     # Show all available commands
```

### Documentation

For detailed documentation, see [DOCKER.md](DOCKER.md).