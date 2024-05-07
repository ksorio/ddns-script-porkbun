# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#
# This is a dynamic DNS script for Openwrt to send updates to Porkbun.

# Check configurations
[ -z "$CURL" ] && write_log 13 "Curl not found"
[ -z "$username" ] && write_log 13 "Missing API public"
[ -z "$password" ] && write_log 13 "Missing API secret"
[ -z "$domain" ] && write_log 13 "Missing domain"

# Force HTTPS
[ $use_https -eq 0 ] && use_https=1

# The type of resources record to add
[ $use_ipv6 -eq 0 ] && rrtype="A" || rrtype="AAAA"

# The value for the resource record (aka IP address)
rrvalue=$__IP

# The value for the TTL of the resource record
if [[ -z $param_opt ]]; then
   rrttl=$param_opt
else
   rrttl=600
fi

# Domain and subdomain
real_domain=$(echo $domain | grep -oE [a-zA-Z0-9]+\.[a-zA-Z0-9]+$)
subdomain=${domain%".$real_domain"}
if [[ $real_domain == $subdomain ]]; then
   subdomain=
fi

# Get Porkbun's current resource record 
old_rrvalue=$(curl -s -X POST "https://porkbun.com/api/json/v3/dns/retrieveByNameType/$real_domain/$rrtype/$subdomain" -H "Content-Type: application/json" --data "{ \"apikey\": \"$username\", \"secretapikey\": \"$password\" }" | grep -oE 'content":"([0-9.]+|[0-9a-fA-F:]+)"' | grep -oE '"([0-9][0-9.]+|[0-9a-fA-F][0-9a-fA-F:]+)"' | grep -oE '[0-9.]+|[0-9a-fA-F:]+')

write_log 7 "Current IP for the domain is: $old_rrvalue"

# Update resource record if necessary
if [[ $old_rrvalue != $rrvalue ]]; then
   write_log 7 "Updating DNS value because $old_rrvalue != $rrvalue"
   curl -X POST "https://porkbun.com/api/json/v3/dns/editByNameType/$real_domain/$rrtype/$subdomain" -H "Content-Type: application/json" --data "{ \"apikey\": \"$username\", \"secretapikey\": \"$password\", \"content\": \"$rrvalue\", \"type\": \"$rrtype\", \"ttl\": \"$rrttl\"}"
else
   write_log 7 "No need to update DNS value."
fi
