# rrey/terraform-runner

This docker image aims at being a CI runner allowing to handle Terraform content.
The image contains opinionated cool tools around Terraform like:

- [Terraform](https://terraform.io/) : The Terraform CLI itself
- [Terragrunt](https://terragrunt.gruntwork.io/) : A wrapper for Terraform that ease layering.
- [Kitchen-Terraform](https://github.com/newcontext-oss/kitchen-terraform) : A Test Kitchen plugin allowing to handle Terraform testing
- [Inspec](https://www.inspec.io) : The Chef Compliance as code test framework
- [Open Policy Agent](https://www.openpolicyagent.org/) : Open Policy Agent, policy-based control through tfstate
- [conftest](https://github.com/instrumenta/conftest) : Run OPA tests through conftest to ease feedback interpretation

## Other useful tools around Terraform (not in this image)

* [terraform-docs](https://github.com/segmentio/terraform-docs): Get rid of modules documentation gruntwork by using a cli that reads your code and generate a clean markdown (among other formats) documentation.
