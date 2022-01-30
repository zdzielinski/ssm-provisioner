# ssm-provisioner

A script that provides the ability to provision AWS instances via SSM.

**NOTE**: This repository is currently unstable and a work in progress.

## Reasoning

AWS SSM is a secure alternative to SSH for general command execution and remote shell capability.

Unfortunately however, there is no standardized upstream SSM provisioner within the Terraform ecosystem.

This module comes into play as a simple, configurable option for SSM provisioning of AWS instances.

Instead of opening your instance up and provisioning over SSH, why not give this a try?

## Requirements

The following packages must be installed:
* [OpenSSH](https://www.openssh.com/)
* [Terraform](https://www.terraform.io/)
* [AWS CLI](https://aws.amazon.com/cli/)
* [SSM Plugin](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html)

## Usage

TODO - Document how to download and use this project easily.

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

## Examples

A useful example of a working Terraform module is provided within the [example folder](./example).

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

## Documentation

Here are some additional documentation links that may prove valuable for further insight:

* [AWS - Enabling and controlling permissions for SSH connections through Session Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-getting-started-enable-ssh-connections.html)

## Releases

You can find information on releases in the [changelog documentation](./docs/CHANGELOG.md).

## Contributing

If you'd like to help out, please read the [contributing documentation](./docs/CONTRIBUTING.md).

## License

This project uses [the MIT license](./LICENSE.md).