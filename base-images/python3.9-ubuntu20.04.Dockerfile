ARG ENVD_VERSION
ARG ENVD_SSH_IMAGE
FROM ubuntu:20.04 as base

FROM base as base-amd64

FROM base as base-arm64

FROM ${ENVD_SSH_IMAGE}:${ENVD_VERSION} AS envd

FROM base-${TARGETARCH}

ARG TARGETARCH

LABEL maintainer "envd-maintainers <envd-maintainers@tensorchord.ai>"

ENV DEBIAN_FRONTEND noninteractive
ENV PATH="/usr/bin:${PATH}"
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt-get update && \
    apt-get install -y apt-utils && \
    apt-get install -y --no-install-recommends --no-install-suggests --fix-missing \
    bash-static libtinfo5 libncursesw5 \
    # conda dependencies
    bzip2 ca-certificates libglib2.0-0 libsm6 libxext6 libxrender1 mercurial \
    procps subversion wget \
    # envd dependencies
    curl openssh-client git tini sudo zsh vim \
    && rm -rf /var/lib/apt/lists/* \
    # prompt
    && curl --proto '=https' --tlsv1.2 -sSf https://starship.rs/install.sh | sh -s -- -y

COPY --from=envd /usr/bin/envd-ssh /var/envd/bin/envd-ssh
