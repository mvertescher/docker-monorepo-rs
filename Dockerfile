FROM ubuntu:bionic-20190307

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
    perl-modules \
    pkgconf \
    sudo \
    unzip \
    zlib1g-dev

ENV RUST_STABLE_TOOLCHAIN=1.36.0 \
    RUST_NIGHTLY_TOOLCHAIN=nightly-2019-07-01 \
    RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:${PATH}

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | \
    sh -s -- -y --no-modify-path --default-toolchain=${RUST_STABLE_TOOLCHAIN}
RUN rustup component add clippy rustfmt

# Install cargo-make
RUN cargo install cargo-make --version 0.21.0

# Install cargo-bitbake
RUN cargo install cargo-bitbake --version 0.3.10

# Install cargo bench compare tool and grab old benchmark files
RUN cargo install cargo-benchcmp --version 0.3.0

# Install mdbook, mdbook-linkcheck
RUN cargo install mdbook --version 0.2.3 && \
  cargo install mdbook-linkcheck --version 0.2.3

# Install cargo-audit; https://github.com/RustSec/cargo-audit
RUN cargo install cargo-audit --version 0.6.1

# Install cargo-junit https://crates.io/crates/cargo-junit
RUN cargo install cargo-junit --version 0.8.0

# Install cargo-bloat; https://github.com/RazrFalcon/cargo-bloat/releases
RUN cargo install cargo-bloat --version 0.8.0

# Install tarpaulin https://crates.io/crates/cargo-tarpaulin
RUN cargo install cargo-tarpaulin --version 0.8.4

# Install the Rust nightly toolchain
RUN rustup install ${RUST_NIGHTLY_TOOLCHAIN}

# Add link to actual perf binary
RUN [ -f /usr/lib/linux-tools/*/perf ] && ln -s /usr/lib/linux-tools/*/perf /usr/local/bin/perf

# Install the protobuf compiler
ARG PROTOC_URL=https://github.com/protocolbuffers/protobuf/releases/download/v3.6.0/protoc-3.6.0-linux-x86_64.zip
ARG PROTOC_SHA256=84e29b25de6896c6c4b22067fb79472dac13cf54240a7a210ef1cac623f5231d
RUN set -eux; \
    mkdir -p /tmp/protoc; \
    curl -L -o /tmp/protoc/protoc.zip $PROTOC_URL; \
    PROTOC_REMOTE_SHA256=$(sha256sum /tmp/protoc/protoc.zip | awk '{print $1}'); \
    [ "$PROTOC_SHA256" = "$PROTOC_REMOTE_SHA256" ]; \
    cd /tmp/protoc; \
    unzip protoc.zip; \
    cp -r bin /usr/local; \
    cp -r include /usr/local; \
    protoc --version;

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

# Install remark(-cli) and markdownlint for linting markdown files.
RUN npm install -g \
    markdownlint-cli@0.16.0 \
    markdownlint@0.15.0

# Finally, make Rust accessible for all users
RUN chmod -R a+w $RUSTUP_HOME $CARGO_HOME
