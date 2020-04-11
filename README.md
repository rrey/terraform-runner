# rrey/terraform-runner

This docker image aims at being a CI runner allowing to handle Terraform content.
The image contains the Terraform cli and other opinionated cool tools around Terraform like:

- [Terragrunt](https://terragrunt.gruntwork.io/) : A wrapper for Terraform that ease layering.
- [Kitchen-Terraform](https://github.com/newcontext-oss/kitchen-terraform) : A Test Kitchen plugin allowing to handle Terraform testing
- [Inspec](https://www.inspec.io) : The Chef Compliance as code test framework

## Other useful tools around Terraform

* [terraform-docs](https://github.com/segmentio/terraform-docs): Get rid of modules documentation gruntwork by using a cli that reads your code and generate a clean markdown (among other formats) documentation.
