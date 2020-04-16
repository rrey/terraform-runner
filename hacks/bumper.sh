#!/bin/bash -e

DOCKERFILE_PATH="$(git rev-parse --show-toplevel)/Dockerfile"
README_PATH="$(git rev-parse --show-toplevel)/README.md"

function get_terraform_latest() {
    terraform_latest=$(curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest |jq -r .tag_name)
    terraform_latest=${terraform_latest//v}
}

function get_terragrunt_latest() {
    terragrunt_latest=$(curl -s https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest |jq -r .tag_name)
    terragrunt_latest=${terragrunt_latest//v}
}

function get_conftest_latest() {
    conftest_latest=$(curl -s https://api.github.com/repos/instrumenta/conftest/releases/latest |jq -r .tag_name)
    conftest_latest=${conftest_latest//v}
}

function get_opa_latest() {
    opa_latest=$(curl -s https://api.github.com/repos/open-policy-agent/opa/releases/latest |jq -r .tag_name)
    opa_latest=${opa_latest//v}
}

function get_terraform_current() {
    terraform_current=$(awk -F"=" '/ENV TERRAFORM_VERSION/{print $2}' $DOCKERFILE_PATH)
}

function get_terragrunt_current() {
    terragrunt_current=$(awk -F"=" '/ENV TERRAGRUNT_VERSION/{print $2}' $DOCKERFILE_PATH)
}

function get_conftest_current() {
    conftest_current=$(awk -F"=" '/ENV CONFTEST_VERSION/{print $2}' $DOCKERFILE_PATH)
}

function get_opa_current() {
    opa_current=$(awk -F"=" '/ENV OPA_VERSION/{print $2}' $DOCKERFILE_PATH)
}

get_terraform_latest
get_terraform_current

if [ "$terraform_latest" != "$terraform_current" ]; then
    sed -i "s/ENV TERRAFORM_VERSION=.*$/ENV TERRAFORM_VERSION=$terraform_latest/" $DOCKERFILE_PATH
    sed -i "s/Terraform-.*-blueviolet/Terraform-$terraform_latest-blueviolet/" $README_PATH
fi

get_terragrunt_latest
get_terragrunt_current

if [ "$terragrunt_latest" != "$terragrunt_current" ]; then
    sed -i "s/ENV TERRAGRUNT_VERSION=.*$/ENV TERRAGRUNT_VERSION=$terragrunt_latest/" $DOCKERFILE_PATH
    sed -i "s/Terragrunt-.*-blue/Terragrunt-$terragrunt_latest-blue/" $README_PATH
fi

get_opa_latest
get_opa_current

if [ "$opa_latest" != "$opa_current" ]; then
    sed -i "s/ENV OPA_VERSION=.*$/ENV OPA_VERSION=$opa_latest/" $DOCKERFILE_PATH
    sed -i "s/opa-.*-lightgrey/opa-$opa_latest-lightgrey/" $README_PATH
fi

get_conftest_latest
get_conftest_current

if [ "$conftest_latest" != "$conftest_current" ]; then
    sed -i "s/ENV CONFTEST_VERSION=.*$/ENV CONFTEST_VERSION=$conftest_latest/" $DOCKERFILE_PATH
    sed -i "s/conftest-.*-blue/conftest-$conftest_latest-blue/" $README_PATH
fi
