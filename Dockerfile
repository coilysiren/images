FROM ubuntu

RUN mkdir -p /projects
WORKDIR /projects

# APT
RUN apt-get update && apt-get install -y \
  curl \
  git \
  shellcheck \
  build-essential \
  lsb-core

# PYTHON
# https://github.com/python/cpython
# check that python doesn't already exist
ENV PYTHON_VERSION 3.7.3
RUN if command -v python 2>/dev/null; then exit 1; fi
RUN git clone \
  --depth "1" \
  --branch "$PYTHON_VERSION" \
  --config "advice.detachedHead=false" \
  "https://github.com/python/cpython.git"
WORKDIR /projects/cpython
RUN git checkout "$PYTHON_VERSION"
RUN ./configure
RUN make
RUN make test
# RUN python --version

WORKDIR /projects
