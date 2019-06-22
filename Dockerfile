# ubuntu
#   wiki: https://en.wikipedia.org/wiki/Ubuntu
FROM ubuntu:19.10

# docker docs:
#   run - https://docs.docker.com/engine/reference/builder/#run
#   workdir - https://docs.docker.com/engine/reference/builder/#workdir
#   shell - https://docs.docker.com/engine/reference/builder/#shell
#   entrypoint - https://docs.docker.com/engine/reference/builder/#entrypoint
#
# tool docs:
#   bash - https://www.gnu.org/software/bash/manual/html_node/index.html
#   mkdir - http://manpages.ubuntu.com/manpages/bionic/man1/mkdir.1.html (swap ubuntu version as needed)
#
# bash (as oppossed to the default, sh) is required for `set -euxo pipefile` calls.
# "what is `set -euxo pipefile` for?"
#   docs: https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
#   blog post: https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#
RUN mkdir -p /projects
WORKDIR /projects
SHELL ["/bin/bash", "-c"]
ENTRYPOINT ["/bin/bash", "-c"]

# APT
# packages:
#   curl - installs curl https://github.com/curl/curl
#   git - installs git https://git-scm.com/
#   shellcheck - installs https://github.com/koalaman/shellcheck for optional shell syntax linting
#   build-essential - installs gcc / make / etc
#   g++ - for building c++
#   lsb-core - installs lsb_release for optionally inspecting os version
#   zlib1g-dev - installs zlib https://github.com/madler/zlib, necessary for compilation (some resources are compressed)
#   libssl-dev - installs https://github.com/openssl/openssl, necessary for ssl
#   libffi-dev - installs https://sourceware.org/libffi/, necessary for python / ruby / etc to call c code
RUN set -euxo pipefail \
  && apt-get update \
  && apt-get install -y \
    curl \
    git \
    shellcheck \
    build-essential \
    g++ \
    lsb-core \
    zlib1g-dev \
    libssl-dev \
    libffi-dev

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
  && echo "running steps from python build instructions https://github.com/python/cpython#build-instructions" \
  && echo "as an opinionated change, we `make install` without sudo" \
  && ./configure \
  && make \
  && make install \
  && echo "linking 'python' to the recently built python version" \
  && ln -s /usr/local/bin/python3 /usr/local/bin/python \
  && echo "testing that python build and linking was successful" \
  && python -c "import os, platform; assert platform.python_version() == os.getenv('PYTHON_VERSION')" \
  && echo "python install done!"
