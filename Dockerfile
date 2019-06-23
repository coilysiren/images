# ubuntu
#   wiki: https://en.wikipedia.org/wiki/Ubuntu
FROM ubuntu:19.10

# Some installers will avoid prompting you if you have the `DEBIAN_FRONTEND` environment variable
# set to `noninteractive`. The vast majority of Dockerfiles will want to have this set, since
# docker build is often done without a human user involved.
#
# Further, we set it as a docker ARG rather than an ENV. Using it as an ARG will make it be set
# only for the duration of this image build (as opposed to being set for all child-builds of this image).
#
# https://github.com/moby/moby/issues/4032
# https://docs.docker.com/engine/reference/builder/#arg
ARG DEBIAN_FRONTEND=noninteractive

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
#   file - installs https://github.com/file/file, requested by homebrew https://docs.brew.sh/Homebrew-on-Linux#debian-or-ubuntu
#
# docker docs:
#   run - https://docs.docker.com/engine/reference/builder/#run
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
    libffi-dev \
    file

# HOMEBREW
#   website: https://docs.brew.sh/Homebrew-on-Linux
#
# docker docs:
#   env - https://docs.docker.com/engine/reference/builder/#env
#   run - https://docs.docker.com/engine/reference/builder/#run
#
# locale-gen / LC_ALL details: https://github.com/lynncyrin/base-image/issues/44
RUN locale-gen en_US.UTF-8
ENV LC_ALL="en_US.UTF-8"
RUN set -euxo pipefail \
  && git clone https://github.com/Homebrew/brew ~/.linuxbrew/Homebrew \
  && mkdir ~/.linuxbrew/bin \
  && ln -s ../Homebrew/bin/brew ~/.linuxbrew/bin \
  && eval $(~/.linuxbrew/bin/brew shellenv)

# PYTHON
#   website: https://www.python.org/
#   source: https://github.com/python/cpython
#   inspiration: https://github.com/docker-library/python
#
# docker docs:
#   env - https://docs.docker.com/engine/reference/builder/#env
#   run - https://docs.docker.com/engine/reference/builder/#run
ENV PYTHON_VERSION="3.7.3"
RUN set -euxo pipefail \
  && git clone \
    --depth "1" \
    --branch "v$PYTHON_VERSION" \
    --config "advice.detachedHead=false" \
    "https://github.com/python/cpython.git" \
  && cd cpython \
  && echo "running steps from python build instructions https://github.com/python/cpython#build-instructions" \
  && echo "as an opinionated change, we `make install` without sudo" \
  && ./configure \
  && make \
  && make install \
  && echo "linking 'python' to the recently built python version" \
  && ln -s /usr/local/bin/python3 /usr/local/bin/python \
  && echo "testing that python build and linking was successful" \
  && python -c "import os, platform; assert platform.python_version() == os.getenv('PYTHON_VERSION')" \
  && echo "linking 'pip' and updating the pip version" \
  && ln -s /usr/local/bin/pip3 /usr/local/bin/pip \
  && pip install --upgrade pip \
  && echo "installing python packages" \
  && echo "https://github.com/prompt-toolkit/ptpython" \
  && echo "https://github.com/pypa/pipenv" \
  && pip install ptipython pipenv \
  && pipenv --version \
  && echo "python install done!"
