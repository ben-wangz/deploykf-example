#! /bin/bash

DKF_CLI_VERSION="0.1.2"
DKF_CLI_ARCH=$(uname -m | sed -e 's/x86_64/amd64/' -e 's/aarch64/arm64/')
mkdir -p $HOME/bin
DFK_CLI_DEST=$HOME/bin/deploykf

curl -fL "https://github.com/deploykf/cli/releases/download/v${DKF_CLI_VERSION}/deploykf-linux-${DKF_CLI_ARCH}" -o "${DFK_CLI_DEST}"
chmod u+x "${DFK_CLI_DEST}"

deploykf version
