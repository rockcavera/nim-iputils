# v0.2.1 - 2022-03-22
- Added `iputils.cidr.contains()` to check if a given `ip` (IPv4 or IPv6) is in a `cidr` (Cidr4 or Cidr6).

# v0.2.0 - 2020-10-28
- You can define when compiling UseStdNetParseIpAddress (`-d:UseStdNetParseIpAddress`) to use `std.net.parseIpAddres()` as a parser for `iputils.ipv4.parseIpv4()` and `iputils.ipv6.parseIpv6()`.

- `iputils.private.utils` removed.

- `iputils.ipv4.Ipv4` is now stored in the order of big endian bytes. Breaks backward compatibility.

- `iputils.ipv4.parseIpv4` optimized.

- `iputils.ipv4.ipv4ToString` starts result with size 15 and fixed to work with big endian bytes.

- `iputils.ipv4.ipv4ToUInt32` works with both types of endian.

- `iputils.ipv4.uint32ToIpv4` works with both types of endian.

- `iputils.ipv4.cmp` changed to works with bytes in big endian order.

- `iputils.ipv6.Ipv6` is now stored in the order of bytes big endian. Breaks backward compatibility.

- `iputils.ipv6.parseIpv6` optimized and redesigned to capture IPv6 in any format described in RFC4291.

- `iputils.ipv6.ipv6ToString` optimized, starts result with size 45 and fixed to work with big endian bytes.

- `iputils.ipv6.cmp` changed to works with bytes in big endian order.

- `iputils.ipv6.ipv6ModeStandart` global variable removed.

- `iputils.ipv6.Ipv6Mode` has had its enumerators names changed and values redefined. Breaks backward compatibility.

- `iputils.cidr.ipv4RangeToCidr` fixed to work with big endian bytes from `iputils.ipv4.Ipv4`.

- `iputils.cidr.ipv6RangeToCidr` fixed to work with big endian bytes from `iputils.ipv6.Ipv6`.

- `iputils.cidr.cidrToIpv4Range` fixed to work with big endian bytes from `iputils.ipv4.Ipv4`.

- `iputils.cidr.cidrToIpv6Range` fixed to work with big endian bytes from `iputils.ipv6.Ipv6`.

- `iputils.cidr.cidrToString` starts result with 18, when `Cidr4`, or 49, when `Cidr6`.

- `iputils.cidr.listAllCidrContainIpv4` fixed to work with big endian bytes from `iputils.ipv4.Ipv4`.

- `iputils.cidr.listAllCidrContainIpv6` fixed to work with big endian bytes from `iputils.ipv4.Ipv6`.

- `iputils.cidr.cidrContainIpv4` fixed to work with big endian bytes from `iputils.ipv4.Ipv4`.

- `iputils.cidr.cidrContainIpv6` fixed to work with big endian bytes from `iputils.ipv4.Ipv6`.

- Added tests for `iputils.ipv4` (tests\tipv4.nim).

- Added tests for `iputils.ipv6` (tests\tipv6.nim).

# v0.1.0 - 2020-04-15
- initial release