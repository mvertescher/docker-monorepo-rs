FROM ubuntu:bionic-20190307

LABEL maintainer="Matt Vertescher <mvertescher@gmail.com>" \
      url="https://github.com/mvertescher/docker-monorepo-rs"

# This makes apt-get work without interactive shell
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    software-properties-common && add-apt-repository ppa:git-core/ppa

RUN apt-get update && apt-get install -y \
    apt-utils \
    bzip2 \
    cmake \
    curl \
    g++-multilib \
    gcc-multilib \
    git \
    jq \
    lib32z1 \
    libasound2-dev \
    libclang-6.0-dev \
    libcurl4-openssl-dev \
    libdbus-1-dev \
    libssl-dev \
    libsystemd-dev \
    libudev-dev \
    libusb-1.0.0-dev \
    libx11-dev \
    linux-tools-common \
    linux-tools-generic \
    make \
    openssh-client \
    openssl \
    perl-modules \
    pkgconf \
    sudo \
    unzip \
    zlib1g-dev

ENV RUST_STABLE_TOOLCHAIN=1.37.0 \
    RUST_NIGHTLY_TOOLCHAIN=nightly-2019-07-01 \
    RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:${PATH}

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | \
    sh -s -- -y --no-modify-path --default-toolchain=${RUST_STABLE_TOOLCHAIN}

RUN set -eux; \
    rustup component add clippy rustfmt; \
    rustup install ${RUST_NIGHTLY_TOOLCHAIN}; \
    cargo install cargo-audit --version 0.8.1; \
    cargo install cargo-benchcmp --version 0.4.2; \
    cargo install cargo-bitbake --version 0.3.11; \
    cargo install cargo-bloat --version 0.8.3; \
    cargo install cargo-junit --version 0.8.0; \
    cargo install cargo-make --version 0.22.1; \
    cargo install cargo-tarpaulin --version 0.8.6; \
    cargo install cargo-udeps --version 0.1.4; \
    cargo install cargo-update --version 1.8.2; \
    cargo install mdbook --version 0.3.1; \
    cargo install mdbook-linkcheck --version 0.4.0;

# Make Rust accessible for all users
RUN chmod -R a+rw $RUSTUP_HOME $CARGO_HOME

# Add link to actual perf binary
RUN [ -f /usr/lib/linux-tools/*/perf ] && ln -s /usr/lib/linux-tools/*/perf /usr/local/bin/perf

# Install the protobuf compiler
COPY ./install_protoc.sh /tmp/install_protoc.sh
RUN sh /tmp/install_protoc.sh

# Install nodejs
ARG NODEJS_VERSION=v10.16.0
ARG NODEJS_URL=https://nodejs.org/dist/${NODEJS_VERSION}/node-${NODEJS_VERSION}-linux-x64.tar.xz
RUN set -eux; \
    mkdir -p /tmp/nodejs; \
    curl -L -o /tmp/nodejs/nodejs.tar.xz $NODEJS_URL; \
    tar -C /tmp/nodejs -xf /tmp/nodejs/nodejs.tar.xz; \
    cd /tmp/nodejs/node-$NODEJS_VERSION-linux-x64; \
    cp -r bin /usr/local; \
    cp -r include /usr/local; \
    cp -r lib /usr/local; \
    cp -r share /usr/local; \
    npm -v;

# Install markdownlint for linting markdown files.
RUN npm install -g \
    markdownlint-cli@0.16.0 \
    markdownlint@0.15.0

# Install FlameGraph
RUN set -eux; \
    git clone https://github.com/brendangregg/FlameGraph.git /usr/local/FlameGraph; \
    chmod -R +x /usr/local/FlameGraph;
ENV PATH=${PATH}:/usr/local/FlameGraph

# Install rust-unmangle
RUN set -eux; \
    git clone https://github.com/Yamakaky/rust-unmangle.git /usr/local/rust-unmangle; \
    chmod -R +x /usr/local/rust-unmangle; \
    ln -s /bin/sed /usr/bin/sed;
ENV PATH=${PATH}:/usr/local/rust-unmangle
