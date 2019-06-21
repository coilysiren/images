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
# packages:
#   build-essential - installs gcc / make / etc
#   zlib1g-dev - installs zlib for python compiles
#   lsb-core - installs lsb_release for inspecting os version
RUN set -euxo pipefail \
  && apt-get update \
  && apt-get install -y \
    curl \
    git \
    shellcheck \
    build-essential \
    g++ \
    lsb-core \
    zlib1g-dev

# PYTHON
#   website: https://www.python.org/
#   source: https://github.com/python/cpython
ENV PYTHON_VERSION 3.7.3
RUN set -euxo pipefail \
  && git clone \
    --depth "1" \
    --branch "v$PYTHON_VERSION" \
    --config "advice.detachedHead=false" \
    "https://github.com/python/cpython.git" \
  && cd cpython \
  && git checkout "v$PYTHON_VERSION" \
  && ./configure \
  && make \
  && make install \
  echo "done!"
  # && cat `python --version` | sed "s/Python //" | xargs if [[ "$1:" -ne "$PYTHON_VERSION" ]]; then exit 1;
