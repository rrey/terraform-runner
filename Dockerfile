FROM golang:1.14.2-alpine3.11 as gobuilder

ARG GOOS=linux
ARG GOARCH=amd64
ARG CGO_ENABLED=0

RUN apk add --no-cache --update \
    bash \
    binutils \
    build-base \
    ca-certificates \
    curl

ENV TERRAGRUNT_VERSION=0.23.8
ENV TERRAGRUNT_SHA256SUM=659e013f303dacef05fae804bbcfb95ef07033b4303d57be43220422a8d447ff
RUN curl -fsSL -O https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 && \
    echo "${TERRAGRUNT_SHA256SUM}  terragrunt_linux_amd64" > terragrunt_${TERRAGRUNT_VERSION}_SHA256SUMS && \
    sha256sum -c terragrunt_${TERRAGRUNT_VERSION}_SHA256SUMS && \
    mv terragrunt_linux_amd64 /usr/local/bin/terragrunt

ENV TERRAFORM_VERSION=0.12.24
ENV TERRAFORM_SHA256SUM=602d2529aafdaa0f605c06adb7c72cfb585d8aa19b3f4d8d189b42589e27bf11
RUN curl -fsSL -O https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    echo "${TERRAFORM_SHA256SUM}  terraform_${TERRAFORM_VERSION}_linux_amd64.zip" > terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    sha256sum -c terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin/

ENV OPA_VERSION=0.19.1
WORKDIR /opa-build
RUN curl -fsSL "https://codeload.github.com/open-policy-agent/opa/tar.gz/v${OPA_VERSION}" | tar xvz --strip-components=1 && \
    go build && \
    mv opa /usr/local/bin/

ENV CONFTEST_VERSION=0.18.1
ENV CONFTEST_SHA256SUM=f6e0d03e9232770a7c8d5b17a5587f9e5290907bf470136f4db777b8b049a44d
RUN curl -fsSL -O https://github.com/instrumenta/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz && \
    echo "${CONFTEST_SHA256SUM}  conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz" > conftest_${CONFTEST_VERSION}_SHA256SUMS && \
    sha256sum -c conftest_${CONFTEST_VERSION}_SHA256SUMS && \
    tar xz conftest -C /usr/local/bin/ -f conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz

RUN strip --strip-all /usr/local/bin/* && \
    chmod 0755 /usr/local/bin/*

FROM alpine:3.11.5
LABEL maintainer="Rémi REY <rrey94@gmail.com>"

COPY --from=gobuilder /usr/local/bin/ /usr/bin/
COPY Gemfile .

RUN apk add --no-cache --update \
    ruby && \
    apk add --no-cache --update --virtual build-dependencies \
    build-base \
    ruby-dev && \
    gem install bundler && \
    bundle config set no-cache true && \
    bundle install --jobs $(getconf _NPROCESSORS_ONLN) && \
    apk del build-dependencies
