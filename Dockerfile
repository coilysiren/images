FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y \
  curl \
  git \
  shellcheck \
  build-essential

COPY tests.sh tests.sh
RUN chmod a+x tests.sh
