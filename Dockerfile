FROM python:3.11.2-slim
LABEL maintainer="nicholasptran nickptran@gmail.com"

ENV DASH_DEBUG_MODE False
ENV OAUTHLIB_RELAX_TOKEN_SCOPE=1

RUN pip install poetry
RUN pip install gunicorn

RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    apt-utils \
    curl \
    unixodbc-dev \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

COPY poetry.lock poetry.lock
COPY pyproject.toml pyproject.toml

RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi

COPY ./app /app
WORKDIR /app

run useradd -m appuser
user appuser

EXPOSE 3838
CMD ["gunicorn", "-b", "0.0.0.0:8050", "--reload", "app:server"]