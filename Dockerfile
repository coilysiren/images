# ubuntu
#   wiki: https://en.wikipedia.org/wiki/Ubuntu
FROM ubuntu:19.10

# workdir
#   docs: https://docs.docker.com/engine/reference/builder/#workdir
WORKDIR /projects
# run
#   docs: https://docs.docker.com/engine/reference/builder/#run
# mkdir
#   docs: http://manpages.ubuntu.com/manpages/bionic/man1/mkdir.1.html (swap ubuntu version as needed)
RUN mkdir -p /projects
# shell
#   docs: https://docs.docker.com/engine/reference/builder/#shell
# bash
#   docs: https://www.gnu.org/software/bash/manual/html_node/index.html
SHELL ["/bin/bash", "-c"]
# entrypoint
#   docs: https://docs.docker.com/engine/reference/builder/#entrypoint
ENTRYPOINT ["/bin/bash", "-c"]

# "what is `set -euxo pipefile` for?"
#   docs: https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
#   blog post: https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

# APT
RUN set -euxo pipefail \
  && apt-get update \
  && apt-get install -y \
    curl \
    git \
    shellcheck \
    build-essential \
    g++ \
    lsb-core

# PYTHON
#   website: https://www.python.org/
#   source: https://github.com/python/cpython
ENV PYTHON_VERSION 3.7.3
# control test: check that python doesn't already exist
RUN if command -v python 2>/dev/null; then exit 1; fi
RUN git clone \
  --depth "1" \
  --branch "v$PYTHON_VERSION" \
  --config "advice.detachedHead=false" \
  "https://github.com/python/cpython.git"
WORKDIR /projects/cpython
RUN git checkout "v$PYTHON_VERSION"
RUN ./configure
RUN make
RUN make test
# RUN python --version

WORKDIR /projects
