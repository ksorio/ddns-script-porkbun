# Dynamic DNS script using Porkbun's API for Openwrt

This script updates A and AAAA records for domains and subdomains of Porkbun, using the ddns service in Openwrt.\
It's open source, using GPL 3.0 license, and it takes great inspiration from [@lin010151](https://github.com/lin010151)'s Namesilo [script](https://github.com/lin010151/ddns-scripts_namesilo).

## Requirements

- A dynamic public IP address (either IPv4 or IPv6).
- Porkbun API's public and secret key.
- Porkbun API activated for the domain you want to use.
- Curl, can be installed using `opkg install curl`.
- (If using HTTPS) System CA certificates, can be installed using `opkg install ca-certificates`.

## Installation

Copy the script to a path on your Openwrt router. I recommend using ssh. \
Remember to give execute permission to the script: `chmod +x update_porkbun.sh`.

## Usage

TODO
