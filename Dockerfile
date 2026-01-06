# Install uv
FROM python:3.12-slim
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

# Change the working directory to the `app` directory
WORKDIR /app

# Copy the lockfile and `pyproject.toml` into the image
COPY uv.lock /app/uv.lock
COPY pyproject.toml /app/pyproject.toml

# Install dependencies (inside docker, mostly want system install not a venv
RUN pip install uv && uv pip install --system -e .

RUN uv sync --frozen --no-install-project

# Copy the project into the image
COPY . /app

# Sync the project
RUN uv sync --frozen

# Same as above, so here:
RUN uv pip install --system -e . \
    pytest \
    pyright \
    mkdocs \
    mkdocs-material \
    mkdocstrings[python]

# CMD [ "python", "e2/foo.py" ]
CMD ["uv", "run", "pytest"]
