#!/usr/bin/env sh
#
# Installer script for protoc v3.6.0
#

PROTOC_URL=https://github.com/protocolbuffers/protobuf/releases/download/v3.6.0/protoc-3.6.0-linux-x86_64.zip
PROTOC_SHA256=84e29b25de6896c6c4b22067fb79472dac13cf54240a7a210ef1cac623f5231d

set -eux

mkdir -p /tmp/protoc
curl -L -o /tmp/protoc/protoc.zip $PROTOC_URL
PROTOC_REMOTE_SHA256=$(sha256sum /tmp/protoc/protoc.zip | awk '{print $1}')
[ "$PROTOC_SHA256" = "$PROTOC_REMOTE_SHA256" ]
cd /tmp/protoc
unzip -o protoc.zip
cp -r bin /usr/local
cp -r include /usr/local
protoc --version
