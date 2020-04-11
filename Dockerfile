FROM ubuntu:19.10

RUN apt update && apt install -y ruby ruby-dev build-essential wget

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

ENV OPA_VERSION=0.18.0

RUN wget https://github.com/open-policy-agent/opa/releases/download/v${OPA_VERSION}/opa_linux_amd64 && \
    mv opa_linux_amd64 /usr/bin/opa && \
    chmod 755 /usr/bin/opa

ENV CONFTEST_VERSION=0.18.1

RUN wget https://github.com/instrumenta/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_linux_amd64.deb && \
    dpkg -i conftest_${CONFTEST_VERSION}_linux_amd64.deb && \
    rm conftest_${CONFTEST_VERSION}_linux_amd64.deb
