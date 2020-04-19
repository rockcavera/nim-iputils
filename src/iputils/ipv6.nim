import std/strutils

import ./private/utils

type
  Ipv6* = array[16, uint8]

  Ipv6Mode* = enum ## IPv6 textual representation modes.
    Ipv6Normal = 0 ## Normal mode. There is no omission of groups, but there is the removal of leading zeros.
    Ipv6Compress = 1 ## Compressed mode. Removes the largest possible chain of zeros.
    Ipv6Expand = 2 ## Expanded mode. All 8 groups have 4 hexadecimal digits.

var ipv6ModeStandart* = Ipv6Compress ## Sets the standard textual representation for IPv6.

proc parseIpv6*(ip: string): Ipv6 =
  ## Parses a IPv6 value contained in ``ip``.
  template testInvalidAndOverflow(x) =
    try:
      let part = fromHex[uint](parts[x])

      if part > 65535'u:
        raise newException(ValueError, "Invalid IPv6.")

      let b = 15 - (x * 2)

      result[b] = uint8(part shr 8)
      result[b - 1] = uint8(part and 0xFF)

    except:
      raise newException(ValueError, "Invalid IPv6.")

  let
    parts = split(ip, ':')
    h = high(parts)

  if h > 7:
    raise newException(ValueError, "Invalid IPv6.")

  if h < 2:
    raise newException(ValueError, "Invalid IPv6.")

  var
    nullParts = 0
    nullIndex = 0

  for i in 1 ..< h:
    if "" == parts[i]:
      nullIndex = i

      inc(nullParts)

      if nullParts > 1:
        raise newException(ValueError, "Invalid IPv6.")
    
    else:
      testInvalidAndOverflow(i)
    
  if 7 != h and nullParts != 1:
    raise newException(ValueError, "Invalid IPv6.")

  if "" == parts[0]:
    if nullIndex != 1:
      raise newException(ValueError, "Invalid IPv6.")
  
  else:
    testInvalidAndOverflow(0)

  if "" == parts[h]:
    if nullIndex != (high(parts) - 1):
      raise newException(ValueError, "Invalid IPv6.")

  else:
    testInvalidAndOverflow(h)
  
  var b = 15 - (len(parts) * 2)
  
  if b > -1:
    inc(b)

    var p = 0

    while 0'u8 != result[b] or 0'u8 != result[b + 1]:
      swap(result[p], result[b])
      
      inc(p)
      inc(b)
      
      swap(result[p], result[b])

      inc(p)
      inc(b)

proc isIpv6AndStore*(ip: string, stored: var Ipv6): bool =
  ## Returns ``true`` if the value of ``ip`` is a valid IPv6 and store the value into ``stored``.
  try:
    stored = parseIpv6(ip)
    
    return true

  except:
    return false

proc isIpv6*(ip: string): bool =
  ## Returns ``true`` if the value of ``ip`` is a valid IPv6.
  var none: Ipv6

  isIpv6AndStore(ip, none)

# Waiting for Nim to launch the built-in uint128 type
#proc ipv6ToUInt128*(ip: Ipv6): uint128 {.inline.} =
#  cast[uint128](ip)
#
#proc uint128ToIpv6*(ip: uint128): Ipv6 {.inline.} =
#  cast[Ipv6](ip)

proc ipv6ToString*(ip: Ipv6, mode: Ipv6Mode = ipv6ModeStandart): string =
  ## Returns an expanded IPv6 textual representation of ``ip``.
  case mode
  of Ipv6Normal:
    for i in countdown(15, 3, 2):
      add(result, toHex((uint16(ip[i]) shl 8) or uint8(ip[i - 1])))
      add(result, ":")
    
    add(result, toHex((uint16(ip[1]) shl 8) or uint8(ip[0])))
  
  of Ipv6Compress:
    var
      hexs = newSeqOfCap[string](8)
      bestNull = (i: -1, e: -1, q: 0)
      x = 0
      null = (i: 0, e: 0, q: 0)

    for i in countdown(15, 1, 2):
      let hex = toHex((uint16(ip[i]) shl 8) or uint8(ip[i - 1]))

      if "0" == hex:
        add(hexs, "0")

        if 0 == null.q:
          null.i = x

        inc(null.q)

      else:
        add(hexs, hex)

        if 1 < null.q:
          if bestNull.q < null.q:
            bestNull = null

            bestNull.e = x - 1
          
          null = (i: 0, e: 0, q: 0)
      
      inc(x)
    
    if 1 < null.q and bestNull.q < null.q:
      bestNull = null

      bestNull.e = x - 1
    
    if 0 == bestNull.i:
      add(result, ':')
    else:
      add(result, hexs[0])
      

    for i in 1 .. 7:
      if i == bestNull.i:
        add(result, ':')
      elif i == bestNull.e:
        add(result, ':')
      elif i > bestNull.i and i < bestNull.e:
        continue
      else:
        if ':' != result[^1]:
          add(result, ':')
        
        add(result, hexs[i])

  of Ipv6Expand:
    for i in countdown(15, 3, 2):
      add(result, toHex((uint16(ip[i]) shl 8) or uint8(ip[i - 1]), true))
      add(result, ":")
    
    add(result, toHex((uint16(ip[1]) shl 8) or uint8(ip[0]), true))

proc `$`*(ip: Ipv6): string =
  ipv6ToString(ip)

proc cmp*(a, b: Ipv6): int =
  ## Compares IPv6 ``a`` with ``b`` and returns:
  ## * ``0``, if ``a`` is equal to ``b``;
  ## * ``1``, if ``a`` is greater than ``b``; or
  ## * ``-1``, if ``a`` is less than ``b``.
  cmpx(15)