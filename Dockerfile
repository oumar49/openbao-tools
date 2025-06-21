# syntax=docker/dockerfile:1.4
FROM --platform=$BUILDPLATFORM openbao/openbao:2.0 AS base

USER root

# Backup existing bao user info if it exists
RUN if id bao 2>/dev/null; then \
        BAO_UID=$(id -u bao); \
        BAO_GID=$(id -g bao); \
        echo "Existing bao user: UID=$BAO_UID GID=$BAO_GID"; \
    else \
        echo "No existing bao user found"; \
    fi

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

# Ensure bao user exists with proper setup
RUN if ! id bao 2>/dev/null; then \
        adduser -D -s /bin/sh -u 1000 bao; \
    fi && \
    # Verify user exists
    id bao && \
    # Ensure home directory exists
    mkdir -p /home/bao && \
    chown bao:bao /home/bao

USER bao
ENTRYPOINT ["bao"]
CMD ["--help"]