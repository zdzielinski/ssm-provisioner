# ssm-provisioner

Latest version tag - [v0.0.2](https://gitlab.com/zdzielinski/ssm-provisioner/-/tags/v0.0.2).

A script that provides the ability to provision AWS instances via SSM.

**NOTE**: This repository is currently unstable and a work in progress.

**NOTE**: Any commits, tags, or other content before release `v1.0.0` may be deleted or changed.

## Reasoning

AWS SSM is a secure alternative to SSH for general command execution and remote shell capability.

Unfortunately however, there is no standardized upstream SSM provisioner within the Terraform ecosystem.

This module comes into play as a simple, configurable option for SSM provisioning of AWS instances.

Instead of opening your instance up and provisioning over SSH, why not give SSM a try?

## Requirements

The following packages must be installed:
* [OpenSSH](https://www.openssh.com/)
* [Terraform](https://www.terraform.io/)
* [AWS CLI](https://aws.amazon.com/cli/)
* [SSM Plugin](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html)

## Usage

The meat and potatoes of this project lives within the [ssm-provisioner.sh](./ssm-provisioner.sh) script.

One method of using this script is to download it into your module via the latest tag:

```bash
cd <terraform_module> # example, move into your terraform module
mkdir -p scripts && cd scripts # example, move into a scripts directory
```

```bash
# download the latest script via the latest tag
curl -sO https://gitlab.com/zdzielinski/ssm-provisioner/-/raw/v0.0.2/ssm-provisioner.sh
```

Generally, this script would be leveraged within the provisioner of a `null_resource`:

```hcl
resource "null_resource" "provisioner" {
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "${path.module}/scripts/ssm-provisioner/ssm-provisioner.sh"
    environment = {
      SCRIPT      = "${path.module}/scripts/provisioner.sh"
      USERNAME    = "<username>"
      INSTANCE_ID = aws_instance.ec2.id
      AWS_REGION  = var.aws_region
      # nonsensitive required, or provisioner output will be hidden
      PRIVATE_KEY = nonsensitive(tls_private_key.key.private_key_pem)
    }
  }
}
```

## Inputs

All inputs are provided as environment variables.

|Name|Required|Type|Default|Valid Options|Description|
|---|---|---|---|---|---|
|SCRIPT|yes|string|N/A|N/A|The local path of the script to execute on the instance|
|USERNAME|yes|string|N/A|N/A|The username to use when connecting to the instance|
|INSTANCE_ID|yes|string|N/A|N/A|The ID of the instance to connect to|
|AWS_REGION|yes|string|N/A|N/A|The AWS region to use when connecting to the instance|
|PRIVATE_KEY|yes|string|N/A|N/A|The private key content to use when connecting to the instance|
|SSH_COMMAND|no|string|`bash -s`|N/A|The SSH command to use when executing the script|
|SSH_PORT|no|number|`22`|N/A|The SSH port to use when connecting to the instance|
|SSH_TIMEOUT|no|number|`120`|N/A|The SSH timeout to use when connecting to the instance, in seconds|
|SSM_TIMEOUT|no|number|`120`|N/A|The timeout to use when waiting for SSM connection on the instance, in seconds|
|SSM_SLEEP|no|number|`1`|N/A|The time to sleep when waiting for SSM connection on the instance, in seconds|
|DEBUG|no|bool|`false`|`true`, `false`|Enable bash debugging via `set -x`, sensitive output will be still be hidden|

## Examples

Useful examples of working Terraform modules are provided within the [modules folder](./modules).

## Releases

You can browse the latest releases in the [tags page](/-/tags), with more details in the [changelog page](./docs/CHANGELOG.md).

## Contributing

If you'd like to help out, please read the [contributing page](./docs/CONTRIBUTING.md).

## References

You can find additional reference documentation in the [references page](./docs/REFERENCES.md).

## License

This project uses [the MIT license](./LICENSE.md).