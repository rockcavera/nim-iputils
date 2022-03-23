# Nimble packages imports
import pkg/stew/endians2

type
  Ipv4* = array[4, uint8]

when defined(UseStdNetParseIpAddress):
  import std/net

  proc parseIpv4*(ip: string): Ipv4 =
    ## Parses a IPv4 value contained in ``ip``.
    let r = parseIpAddress(ip)

    if r.family == IpAddressFamily.IPv6:
      raise newException(ValueError, "Invalid IPv4.")

    result = r.address_v4
    
else:
  proc parseIpv4*(ip: string): Ipv4 =
    ## Parses a IPv4 value contained in ``ip``.
    var
      b = 0
      x = 0
      empty = true
    
    for c in ip:
      if c in {'0' .. '9'}:
        b = b * 10 + (ord(c) - ord('0'))

        empty = false
        
      elif '.' == c:
        if empty or b > 255:
          raise newException(ValueError, "Invalid IPv4.")

        result[x] = uint8(b)

        inc(x)

        b = 0

        empty = true

        if x > 3:
          raise newException(ValueError, "Invalid IPv4.")

      else:
        raise newException(ValueError, "Invalid IPv4.")
    
    if x != 3 or empty or b > 255:
      raise newException(ValueError, "Invalid IPv4.")

    result[x] = uint8(b)

proc isIpv4AndStore*(ip: string, stored: var Ipv4): bool =
  ## Returns ``true`` if the value of ``ip`` is a valid IPv4 and store the value into ``stored``.
  try:
    stored = parseIpv4(ip)
    
    return true

  except:
    return false

proc isIpv4*(ip: string): bool =
  ## Returns ``true`` if the value of ``ip`` is a valid IPv4.
  var none: Ipv4

  isIpv4AndStore(ip, none)

proc ipv4ToUInt32*(ip: Ipv4): uint32 {.inline.} =
  ## Turns an Ipv4 type into uint32.
  fromBytesBE(uint32, ip)

proc uint32ToIpv4*(ip: uint32): Ipv4 {.inline.} =
  ## Turns a uint32 type into Ipv4.
  toBytesBE(ip)

proc ipv4ToString*(ip: Ipv4): string =
  ## Returns an IPv4 textual representation of an ``ip``.
  result = newStringOfCap(15)
  
  for i in 0 .. 2:
    add(result, $ip[i])
    add(result, ".")
  
  add(result, $ip[3])

proc `$`*(ip: Ipv4): string =
  ipv4ToString(ip)

proc cmp*(a, b: Ipv4): int =
  ## Compares IPv4 ``a`` with ``b`` and returns:
  ## * ``0``, if ``a`` is equal to ``b``;
  ## * ``1``, if ``a`` is greater than ``b``; or
  ## * ``-1``, if ``a`` is less than ``b``.
  for i in 0 .. 3:
    if a[i] == b[i]:
      continue
    elif a[i] < b[i]:
      return -1
    else:
      return 1
  return 0
