FROM ubuntu

RUN mkdir -p /projects
WORKDIR /projects

# APT
RUN apt-get update
RUN apt-get install -y \
  curl \
  git \
  shellcheck \
  build-essential
RUN \
  curl --version \
  git --version \
  shellcheck --version \
  gcc --version \
  make --version

# PYTHON
# check that python doesn't already exist
RUN if command -v python 2>/dev/null; then exit 1; fi
RUN git clone https://github.com/python/cpython.git
WORKDIR /projects/cpython
RUN git checkout v3.7.3
RUN ./configure
RUN make
RUN python --version

WORKDIR /projects
