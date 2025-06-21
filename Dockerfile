# syntax=docker/dockerfile:1.4
FROM --platform=$BUILDPLATFORM openbao/openbao:2.0 AS base

USER root
RUN apk add --no-cache \
    bash curl vim openssl jq

# Install kubectl
ARG KUBECTL_VERSION=v1.30.0
RUN curl -sSL "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
    -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl

# Install yq
ARG YQ_VERSION=v4.45.0
RUN curl -sSL "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64" \
    -o /usr/local/bin/yq \
 && chmod +x /usr/local/bin/yq

# Use numeric UID (most reliable approach)
USER 1000
ENTRYPOINT ["bao"]
CMD ["--help"]