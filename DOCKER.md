# Docker MkDocs Environment

This Docker image provides a ready-to-use MkDocs environment for documenting multiple projects.

## Features

- **MkDocs (latest)** - Static site generator for project documentation
- **Material for MkDocs** - Modern, responsive documentation theme
- **Popular Plugins**:
  - mkdocs-material - Material theme
  - mkdocs-minify-plugin - Minify HTML, JS, and CSS
  - mkdocs-redirects - Create page redirects
  - mkdocs-git-revision-date-localized-plugin - Display git revision dates
  - mkdocs-awesome-pages-plugin - Customize page ordering
  - mkdocs-macros-plugin - Use variables and macros in docs
  - mkdocs-monorepo-plugin - Support for multiple projects in a monorepo
  - pymdown-extensions - Extended Markdown support

All package versions are automatically managed via `requirements.txt`.

## Building the Docker Image

```bash
docker build -t mkdocs-env .
```

Or using the Makefile:

```bash
make build
```

### Testing the Setup

Run the automated test script to verify everything works:

```bash
./test-docker.sh
# Or using make
make test
```

This will build the image, create a test project, and verify the documentation builds correctly.

## Running the Container

### Using Makefile (Recommended)

```bash
# Serve documentation
make serve

# Build static site
make build-docs

# Create new project
make new PROJECT=my-docs

# Open shell in container
make shell

# See all commands
make help
```

### For a single project

```bash
docker run -it --rm -p 8000:8000 -v $(pwd):/docs mkdocs-env
```

### For multiple projects (monorepo)

```bash
docker run -it --rm -p 8000:8000 -v /path/to/projects:/docs mkdocs-env
```

### Running with a custom command

```bash
# Build the documentation
docker run -it --rm -v $(pwd):/docs mkdocs-env mkdocs build

# Create a new MkDocs project
docker run -it --rm -v $(pwd):/docs mkdocs-env mkdocs new my-project

# Interactive shell
docker run -it --rm -v $(pwd):/docs mkdocs-env /bin/bash
```

## Usage Examples

### Quick start with example configuration

```bash
# Copy the example configuration
cp mkdocs.yml.example mkdocs.yml

# Create a docs directory with sample content
mkdir -p docs
echo "# Welcome" > docs/index.md
echo "# About" > docs/about.md

# Run MkDocs server
docker run -it --rm -p 8000:8000 -v $(pwd):/docs mkdocs-env
```

Then visit http://localhost:8000 in your browser.

### Initialize a new project

```bash
docker run -it --rm -v $(pwd):/docs mkdocs-env mkdocs new my-documentation
cd my-documentation
docker run -it --rm -p 8000:8000 -v $(pwd):/docs mkdocs-env
```

Then visit http://localhost:8000 in your browser.

### Serve existing documentation

```bash
# From your project directory containing mkdocs.yml
docker run -it --rm -p 8000:8000 -v $(pwd):/docs mkdocs-env
```

### Build static site

```bash
docker run -it --rm -v $(pwd):/docs mkdocs-env mkdocs build
```

The built site will be in the `site/` directory.

## Environment Details

- **Base Image**: python:3.11-slim
- **Working Directory**: /docs
- **Exposed Port**: 8000
- **Default Command**: `mkdocs serve --dev-addr=0.0.0.0:8000`

## Docker Compose Example

Create a `docker-compose.yml` file:

```yaml
version: '3.8'

services:
  mkdocs:
    build: .
    ports:
      - "8000:8000"
    volumes:
      - ./:/docs
    command: mkdocs serve --dev-addr=0.0.0.0:8000
```

Run with:

```bash
docker-compose up
```

## Tips

- The container runs as root by default. Mount your docs directory with appropriate permissions.
- Use `-p 8000:8000` to map the MkDocs server port to your host.
- Mount your documentation directory to `/docs` in the container.
- The `--rm` flag removes the container after it exits.
- For live reload during development, make sure to use `mkdocs serve` with the dev server.
