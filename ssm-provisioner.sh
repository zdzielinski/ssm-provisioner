#!/usr/bin/env bash

# ssm-provisioner.sh
# https://gitlab.com/zdzielinski/ssm-provisioner
# v0.0.3

# The MIT License
# Copyright 2022 Zachariah Dzielinski
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# exit on error
set -e

# enable debug mode if specified
DEBUG="${DEBUG:-false}"
[[ "$DEBUG" = "true" ]] && set -x

# defaulted variables
SSH_COMMAND="${SSH_COMMAND:-"bash -s"}"
SSH_PORT="${SSH_PORT:-22}"
SSH_TIMEOUT="${SSH_TIMEOUT:-120}"
SSM_TIMEOUT="${SSM_TIMEOUT:-120}"
SSM_SLEEP="${SSM_SLEEP:-1}"

# verify client tools are installed
which aws >/dev/null || { >&2 echo "Error: The `aws` command is not installed"; exit 1; }

# verify existence of required variables
[ -z "${SCRIPT}" ] && { >&2 echo "Error: The `SCRIPT` environment variable is not set"; exit 1; }
[ -z "${USERNAME}" ] && { >&2 echo "Error: The `USERNAME` environment variable is not set"; exit 1; }
[ -z "${INSTANCE_ID}" ] && { >&2 echo "Error: The `INSTANCE_ID` environment variable is not set"; exit 1; }
[ -z "${AWS_REGION}" ] && { >&2 echo "Error: The `AWS_REGION` environment variable is not set"; exit 1; }
[[ "$DEBUG" = "true" ]] && set +x # hide sensitive content when debugging
[ -z "${PRIVATE_KEY}" ] && { >&2 echo "Error: The `PRIVATE_KEY` environment variable is not set"; exit 1; }
[[ "$DEBUG" = "true" ]] && set -x # reset into debug mode afterwards

# verify script path exists as a file
test -f $SCRIPT || { >&2 echo "Error: Could not find script `$SCRIPT`"; exit 1; }

# random tag name
RANDOM_TAG=$(printf "%04x" $RANDOM $RANDOM $RANDOM $RANDOM)

# temporary ssh config with random tag name
TMP_SSH_CONFIG=/tmp/$RANDOM_TAG.ssm_provisioner_ssh_config

cleanup () {
  # store original code
  ARG=$?
  # clean the temporary ssh config
  rm -f $TMP_SSH_CONFIG
  # exit with original code
  exit $ARG
}

# run cleanup on exit
trap cleanup EXIT

# clean and create temporary ssh config
rm -f $TMP_SSH_CONFIG
cat <<EOF > $TMP_SSH_CONFIG
host i-* mi-*
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
  ProxyCommand sh -c "aws --region $AWS_REGION ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"
EOF

# wait until ssm is available on the instance
NEXT_WAIT_TIME=0
until [ $NEXT_WAIT_TIME -ge $SSM_TIMEOUT ] || [ "$SSM_STATUS" = "connected" ]; do
  sleep $SSM_SLEEP
  NEXT_WAIT_TIME=$((NEXT_WAIT_TIME+SSM_SLEEP))
  SSM_STATUS=$(aws ssm get-connection-status --target $INSTANCE_ID --query Status --output text)
done

# error out if ssm could not connect before timeout
[ "$SSM_STATUS" != "connected" ] && { >&2 echo "Error: Timeout waiting for SSM to become connected on instance `$INSTANCE_ID`"; exit 1; }

# ingest the private key
eval $(ssh-agent) >/dev/null
[[ "$DEBUG" = "true" ]] && set +x # hide sensitive content when debugging
echo "$PRIVATE_KEY" | tr -d '\r' | ssh-add - >/dev/null
[[ "$DEBUG" = "true" ]] && set -x # reset into debug mode afterwards

# ingest and execute the script
ssh -F $TMP_SSH_CONFIG \
  -p $SSH_PORT \
  -o ConnectTimeout=$SSH_TIMEOUT \
  $USERNAME@$INSTANCE_ID \
  $ENVIRONMENT $SSH_COMMAND < $SCRIPT