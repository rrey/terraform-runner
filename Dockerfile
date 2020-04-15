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
RUN curl -fsSL -o /usr/local/bin/terragrunt \
      https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64

ENV TERRAFORM_VERSION=0.12.24
RUN curl -fsSL -O https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin/

ENV OPA_VERSION=0.19.1
WORKDIR /opa-build
RUN curl -fsSL "https://codeload.github.com/open-policy-agent/opa/tar.gz/v${OPA_VERSION}" | tar xvz --strip-components=1 && \
    go build && \
    mv opa /usr/local/bin/

ENV CONFTEST_VERSION=0.18.1
RUN curl -fsSL https://github.com/instrumenta/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz | \
      tar xz conftest -C /usr/local/bin/

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
