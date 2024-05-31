## Utilities for use with IP. It has functions for IPv4, IPv6 and CIDR.
##
## By rockcavera (rockcavera@gmail.com)
##
## Basic usage
## ===========
##
## .. code-block::
##   import iputils
##
##   let stringsIps = @["192.168.0.63", "0.0.0", "0", "256.0.0.1", "::1", "0:0:0:0:0:0:0:0", "2607:5300:60:37df::c4f3", ":::1"]
##
##   for ip in stringsIps:
##     if isIpv4(ip):
##       echo ip, " is IPv4!"
##
##     elif isIpv6(ip):
##       echo ip, " is IPv6!"
##
##     else:
##       echo ip, " not is IPv4 or IPv6!"
##
##   for ip in stringsIps:
##     try:
##       let parsed = parseIpv4(ip)
##     except:
##       echo ip, " could not parse how IPv4."
##
##     try:
##       let parsed = parseIpv6(ip)
##     except:
##       echo ip, " could not parse how IPv6."
##
##   for ip in stringsIps:
##     var
##       ipv4: Ipv4
##       ipv6: Ipv6
##
##     if isIpv4AndStore(ip, ipv4):
##       echo "Stored: ", ipv4
##
##     elif isIpv6AndStore(ip, ipv6):
##       echo "Stored: ", ipv6
##
##
##   let
##     startIpv4 = parseIpv4("192.168.0.0")
##     endIpv4 = parseIpv4("192.168.5.100")
##     cidrs4 = ipv4RangeToCidr(startIpv4, endIpv4)
##
##   for cidr in cidrs4:
##     let (i, e) = cidrToIpv4Range(cidr)
##
##     echo cidr, " contains IPv4 between ", i, " - ", e
##
##   let
##     startIpv6 = parseIpv6("2607:5300:60:37df::c4f3")
##     endIpv6 = parseIpv6("2607:5300:60:37df::ff:ffff")
##     cidrs6 = ipv6RangeToCidr(startIpv6, endIpv6)
##
##   for cidr in cidrs6:
##     let (i, e) = cidrToIpv6Range(cidr)
##
##     echo cidr, " contains IPv6 between ", i, " - ", e

# Internal imports
import ./iputils/[ipv4, ipv6, cidr]

export ipv4, ipv6, cidr
