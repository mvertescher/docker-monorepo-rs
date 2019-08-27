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

# add link to actual perf binary. this should be compatible with any host linux
# version
RUN [ -f /usr/lib/linux-tools/*/perf ] && ln -s /usr/lib/linux-tools/*/perf /usr/local/bin/perf

# Install nodejs
ARG NODEJS_VERSION=v10.16.0
ARG NODEJS_URL=https://nodejs.org/dist/${NODEJS_VERSION}/node-${NODEJS_VERSION}-linux-x64.tar.xz
RUN bash -c "mkdir -p /home/${UNAME}/nodejs \
  && curl -L -o /home/${UNAME}/nodejs/nodejs.tar.xz $NODEJS_URL \
  && tar -C /home/${UNAME}/nodejs -xf /home/${UNAME}/nodejs/nodejs.tar.xz"
ENV PATH="/home/${UNAME}/nodejs/node-$NODEJS_VERSION-linux-x64/bin:${PATH}"

# Install remark(-cli) and markdownlint for linting markdown files.
RUN npm install -g \
  markdownlint-cli@0.16.0 \
  markdownlint@0.15.0

# Install rust stable toolchain
ENV RUST_STABLE_TOOLCHAIN=1.36.0
RUN curl -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain=${RUST_STABLE_TOOLCHAIN}
# ENV PATH="/home/${UNAME}/.cargo/bin:${PATH}"
ENV PATH="/root/.cargo/bin:${PATH}"
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

# Install rust nightly toolchain
ENV RUST_NIGHTLY_TOOLCHAIN=nightly-2019-07-01
RUN rustup install ${RUST_NIGHTLY_TOOLCHAIN}
