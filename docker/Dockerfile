# Venom Dockerfile
#
# This file is part of Venom
# See LICENSE for license details.

ARG PYTHON_VERSION=3.10

FROM docker.io/python:${PYTHON_VERSION}-slim-bullseye as builder

# Contact info for critical/security issues only
# Use subject title "Venom *critical issue*: short description"
LABEL maintainer="The Architect" \
      email="fbiwastaken@riseup.net"

# Install base dependencies
ARG V_ENV \
    # Needed for fixing permissions of files created by Docker:
    UID=9001 \
    GID=9001

ENV V_ENV=${V_ENV} \
    # python
    PYTHONFAULTHANDLER=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONHASHSEED=random \
    PYTHONDONTWRITEBYTECODE=1 \
    # pip
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_DEFAULT_TIMEOUT=100 \
    PIP_ROOT_USER_ACTION=ignore \
    # poetry
    POETRY_VERSION=1.4.2 \
    POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_CREATE=false \
    POETRY_CACHE_DIR='/var/cache/pypoetry' \
    POETRY_HOME='/usr/local'

RUN \
  apt-get update -qq && apt-get install -yqq \
    git \
    gcc \
    curl \
    build-essential \
    python3-setuptools \
    python3-dev \
    python3-bs4 \
    ca-certificates \
    libffi-dev \
    # Install Poetry (package manager for Python)
  && curl -sSL https://install.python-poetry.org | POETRY_VERSION=${POETRY_VERSION} python3 - \
  && poetry --version \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && apt-get clean -y && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

# Clone repo & install dependencies
RUN git clone --depth=1 https://github.com/V3n0M-Scanner/V3n0M-Scanner.git ./scan

RUN groupadd -g "${GID}" -r venom \
  && useradd -d '/opt/scan' -g venom -l -r -u "${UID}" venom \
  && chown venom:venom -R '/opt/scan'

USER venom

# Use pip for the rest
RUN pip install aiohttp tqdm SocksiPy-branch httplib2 requests bs4 dnspython

WORKDIR /opt/scan/src

# Run Venom
CMD ["python3", "v3n0m.py"]
