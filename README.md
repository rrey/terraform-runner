# rrey/terraform-runner

![Build](https://github.com/rrey/terraform-runner/workflows/Docker%20Image%20CI/badge.svg)
![](https://img.shields.io/badge/Terraform-1.0.6-blueviolet)
![](https://img.shields.io/badge/Terragrunt-0.31.10-blue)
![](https://img.shields.io/badge/opa-0.32.0-lightgrey)
![](https://img.shields.io/badge/conftest-0.27.0-blue)

This docker image aims at being a CI runner allowing to handle Terraform content.
The image contains opinionated cool tools around Terraform like:

- [Terraform](https://terraform.io/) : The Terraform CLI itself
- [Terragrunt](https://terragrunt.gruntwork.io/) : A wrapper for Terraform that ease layering.
- [Kitchen-Terraform](https://github.com/newcontext-oss/kitchen-terraform) : A Test Kitchen plugin allowing to handle Terraform testing
- [Inspec](https://www.inspec.io) : The Chef Compliance as code test framework
- [Open Policy Agent](https://www.openpolicyagent.org/) : Open Policy Agent, policy-based control through Terraform plan
- [conftest](https://github.com/instrumenta/conftest) : Run OPA tests through conftest to ease feedback interpretation

See it in action [here](https://github.com/rrey/terraform-test-sample/blob/master/.github/workflows/ci.yml)

## Tags

This image has different tag strategies:

* `vX.Y.Z`: Regular SemVer tag with alpine base image.
* `vX.Y.Z-azdo`: Image based on [rre/azdo-base-container](https://hub.docker.com/repository/docker/rrey/azdo-base-container) making the image usable on azure devops.

## Other useful tools around Terraform (not in this image)

* [terraform-docs](https://github.com/segmentio/terraform-docs): Get rid of modules documentation gruntwork by using a cli that reads your code and generate a clean markdown (among other formats) documentation.
* [pre-commit-terraform](https://github.com/antonbabenko/pre-commit-terraform): Add Git hooks on your repository to be sure that command are executed.
