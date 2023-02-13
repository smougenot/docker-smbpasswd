#!/usr/bin/env bash

set -o errexit    # always exit on error
set -o pipefail   # honor exit codes when piping
set -o nounset    # fail on unset variables

dir=$(cd -P -- "$(dirname -- "$BASH_SOURCE[0]")" && pwd -P)

echo "Building image"
docker build --file "${dir}/Dockerfile" --tag smbpasswd

_domain="172.17.4.23"
_user="${USERNAME}"

read -e -p "Enter domain:" -i "${_domain}" _domain
read -e -p "Enter user:" -i "${_user}" _user
docker run --interactive --rm smbpasswd "${_user}" "${_domain}"
