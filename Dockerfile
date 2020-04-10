FROM alpine:3.11

RUN apk --no-cache add bash \
          ca-certificates   \
          git               \
          openssh-client    \
          gcc               \
          libc-dev          \
          libstdc++         \
          make              \
          ruby              \
          ruby-dev          \
          ruby-etc          \
          ruby-rdoc         \
          && rm -rf /var/cache/apk/*

COPY Gemfile .
RUN gem install bundler
RUN bundle install

ENV TERRAGRUNT_VERSION=0.23.8

RUN wget https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 && \
    mv terragrunt_linux_amd64 /usr/bin/terragrunt && \
    chmod 755 /usr/bin/terragrunt

ENV TERRAFORM_VERSION=0.12.24

RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/bin/ && \
    chmod 755 /usr/bin/terraform && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

