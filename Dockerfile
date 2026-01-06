FROM python:3.12-slim

# Change the working directory to the `app` directory
WORKDIR /app

# Install uv
# COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv
RUN pip install uv

# Copy the project metadata
COPY pyproject.toml ./

# Install dependencies into system Python
RUN uv pip install --system .

# Copy source code
COPY src ./src

# Install your project (non-editable)
RUN uv pip install --system .

# Copy tests and docs
COPY tests ./tests
COPY docs ./docs
COPY mkdocs.yml .

CMD ["uv", "run", "pytest"]
