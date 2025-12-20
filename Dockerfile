FROM debian:stable

RUN apt-get update \
 && apt-get install -y --no-install-recommends build-essential curl unzip zlib1g-dev libpcre2-dev perl ca-certificates

ENV UPX_VERSION=5.0.2

RUN ARCH=$(dpkg --print-architecture) \
 && if [ "$ARCH" = "amd64" ]; then UPX_ARCH="amd64_linux"; \
    elif [ "$ARCH" = "arm64" ]; then UPX_ARCH="arm64_linux"; \
    else echo "Unsupported architecture: $ARCH" && exit 1; fi \
 && curl -L -o /tmp/upx.tar.xz https://github.com/upx/upx/releases/download/v${UPX_VERSION}/upx-${UPX_VERSION}-${UPX_ARCH}.tar.xz \
 && tar -xf /tmp/upx.tar.xz -C /tmp \
 && mv /tmp/upx-${UPX_VERSION}-${UPX_ARCH}/upx /usr/local/bin/upx

FROM scratch

COPY --from=0 /usr/local/bin/upx /upx

ENTRYPOINT ["/upx"]
