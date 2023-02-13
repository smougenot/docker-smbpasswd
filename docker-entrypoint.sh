#!/bin/sh
set -e
test ! -z "$DEBUG" && set -x

is_ip() {
  _domain="$1"
  if python3 -c "import ipaddress; ipaddress.ip_address('${_domain}')" 2>/dev/null; then
      echo "${_domain}"
  fi
}

dc_ip_address() {
    _domain="$1"
    _is_ip="$(is_ip "$_domain")"
    if [[ -z "$_is_ip" ]]; then
      dig A +short $(dig -t SRV _ldap._tcp.dc._msdcs."$_domain" +short | cut -d' ' -f4) | \
          head -n 1
    else
      echo "${_is_ip}"
    fi
}

main() {
    _username="$1"
    [ -z "$_username" ] && echo "Username is required" && exit 100

    _domain="$2"
    [ -z "$_domain" ] && echo "Domain is required" && exit 100

    _ip_address=$(dc_ip_address "$_domain")
    echo "Contacting domain on $_ip_address"
    /usr/bin/smbpasswd -U "$_username" -r "$_ip_address"
}

main "$@"
