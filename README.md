# Dynamic DNS script using Porkbun's API for Openwrt

This script updates A and AAAA records for domains and subdomains of Porkbun, using the ddns service in Openwrt.\
It's open source, using GPL 3.0 license, and it takes great inspiration from [@lin010151](https://github.com/lin010151)'s Namesilo [script](https://github.com/lin010151/ddns-scripts_namesilo).

## Requirements

- A dynamic public IP address (either IPv4 or IPv6).
- Porkbun API's public and secret key.
- Porkbun API activated for the domain you want to use.
- An existing `A` record on your domain (you should delete the `CNAME` and `ALIAS` records they start new domains with).
- Curl, can be installed using `opkg install curl`.
- (If using HTTPS) System CA certificates, can be installed using `opkg install ca-certificates`.

## Installation

Copy the script to a path on your Openwrt router. I recommend using ssh. \
You may also download it directly from GitHub to your router: `wget https://raw.githubusercontent.com/ksorio/ddns-script-porkbun/main/update_porkbun.sh` \
Remember to give execute permission to the script: `chmod +x update_porkbun.sh`.

## Usage (LuCI web GUI)

- Install the LuCI DDNS web GUI using `opkg install luci-app-ddns` and open `<YOUR_ROUTER>/cgi-bin/luci/admin/services/ddns`.
- Click "Add new services"; give it a name (like "porkbun") and choose the "-- custom --" provider.
- Edit the entry and set the following fields:
  - `Lookup Hostname` => your domain name
  - `Custom update-script` => the path to update_porkbun.sh on your router
  - `Domain` => your domain name
  - `Username` => Your Porkbun API key (not the secret!)
  - `Password` => Your Porkbun API secret
  - (optional) `Optional Parameter` => your desired TTL (must be >= 600)
  - (optional) `Use HTTP Secure` => true
  - (optional) `Path to CA-Certificate` => /etc/ssl/certs
- Configure anything else to your liking, then click Save

## Usage (command line)

Sample config section (you may choose different values for some, but fields with UPPERCASE values require your input):

```
config service 'porkbun'
        option enabled '1'
        option domain 'YOUR_DOMAIN'
        option lookup_host 'YOUR_DOMAIN'
        option update_script 'PATH_TO_UPDATE_SCRIPT'
        option username 'YOUR_PORKBUN_API_KEY'
        option password 'YOUR_PORKBUN_API_KEY_SECRET'
        option use_https '1'
        option cacert '/etc/ssl/certs'
        option ip_source 'network'
        option ip_network 'wan'
        option interface 'wan'
        option param_opt '600'
```

The `param_opt` value controls the TTL value sent to Porkbun (in seconds). The minimum they will accept is 600; trying to use anything lower will result in the actual value being set to 600.

You can manually try a test run with: `/usr/lib/ddns/dynamic_dns_updater.sh -S porkbun -v1 start`
