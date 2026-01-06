FROM python:3.12-slim

# Change the working directory to the `app` directory
WORKDIR /app

# Install uv
# COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv
RUN pip install uv

# Copy the `pyproject.toml` and the lockfile into the image
COPY pyproject.toml /app/pyproject.toml
COPY uv.lock /app/uv.lock

# Install dependencies (inside docker, mostly want system install not a venv
# 'uv pip install...' cannot work during a Docker build
# Editable installs ( -e . ) are for development, NOT containers
# Use a normal install (remove '-e'):
# No project install yet)
RUN uv sync --system --frozen --no-install-project

# Copy source code
COPY src ./src

# Install your project:
RUN uv pip install --system .

# Copy the project into the image
COPY . /app

# Sync the project
RUN uv sync --frozen

# Same as above, so here:
RUN uv pip install --system . \
    pytest \
    pyright \
    mkdocs \
    mkdocs-material \
    mkdocstrings[python]

# CMD [ "python", "e2/foo.py" ]
CMD ["uv", "run", "pytest"]
