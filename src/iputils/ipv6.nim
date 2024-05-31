# Std imports
import std/strutils

type
  Ipv6* = array[16, uint8]

  Ipv6Mode* = enum ## IPv6 textual representation modes.
    Ipv6Compressed = 0 ## Compressed mode. Removes the largest possible chain of zeros. According to https://tools.ietf.org/html/rfc5952#section-4
    Ipv6LeadingZeros = 1 ## Leading zeros removed mode. There is no omission of groups, but there is the removal of leading zeros.
    Ipv6Expanded = 2 ## Expanded mode. All 8 groups have 4 hexadecimal digits.

when defined(UseStdNetParseIpAddress):
  import std/net

  proc parseIpv6*(ip: string): Ipv6 =
    ## Parses a IPv6 value contained in ``ip``.
    let r = parseIpAddress(ip)

    if r.family == IpAddressFamily.IPv4:
      raise newException(ValueError, "Invalid IPv6.")

    result = r.address_v6

else:
  proc parseIpv6*(ip: string): Ipv6 =
    ## Parses a IPv6 value contained in ``ip``. According to https://tools.ietf.org/html/rfc4291
    let ipLength = len(ip)

    if ipLength < 2 or ipLength > 45:
      raise newException(ValueError, "Invalid IPv6.")

    var
      a = 0
      b = 0
      x = 0
      i = 0
      iNullPart = -1

    block outMainLoop:
      while a < ipLength:
        let c = ip[a]

        case c
        of {'0' .. '9'}:
          b = b shl 4 or (ord(c) - ord('0'))

          inc(x)
        of {'A' .. 'F'}:
          b = b shl 4 or (ord(c) - ord('A') + 10)

          inc(x)
        of {'a' .. 'f'}:
          b = b shl 4 or (ord(c) - ord('a') + 10)

          inc(x)
        of ':':
          if 0 == x:
            if 0 != a:
              if iNullPart > -1:
                raise newException(ValueError, "Invalid IPv6.")
              else:
                iNullPart = i

                if a == (ipLength - 1):
                  inc(a)

                  break
            elif ':' == ip[1]:
              iNullPart = i

              inc(a)
            else:
              raise newException(ValueError, "Invalid IPv6.")

            inc(i, 2)
          else:
            result[i] = uint8((b and 65280) shr 8)

            inc(i)

            result[i] = uint8(b and 255)

            inc(i)

            b = 0
            x = 0

          inc(a)

          if i > 14:
            raise newException(ValueError, "Invalid IPv6.")

          continue
        of '.':
          if 0 == x or b > 597 or i < 2:
            raise newException(ValueError, "Invalid IPv6.")

          if b > 9:
            b = ((((b and 768) shr 8) * 10) + ((b and 240) shr 4)) * 10 + (b and 15)

          result[i] = uint8(b)

          inc(i)
          inc(a)

          b = 0
          x = 0

          var ipv4Parts = 1

          while a < ipLength:
            let c2 = ip[a]

            case c2
            of {'0' .. '9'}:
              b = b * 10 + (ord(c2) - ord('0'))

              inc(x)
            of '.':
              if x == 0 or b > 255:
                raise newException(ValueError, "Invalid IPv4.")

              result[i] = uint8(b)

              inc(i)
              inc(ipv4Parts)

              b = 0
              x = 0

              if i > 15:
                raise newException(ValueError, "Invalid IPv4.")
            else:
              raise newException(ValueError, "Invalid IPv4.")

            inc(a)

          if ipv4Parts != 3 or x == 0 or b > 255:
            raise newException(ValueError, "Invalid IPv4.")

          result[i] = uint8(b)

          inc(i)

          break outMainLoop

        else:
          raise newException(ValueError, "Invalid IPv6.")

        if x > 4:
          raise newException(ValueError, "Invalid IPv6.")

        inc(a)

      if 0 == x:
        if iNullPart > -1 and ':' == ip[a - 2]:
          inc(i, 2)
        else:
          raise newException(ValueError, "Invalid IPv6.")

      else:
        result[i] = uint8((b and 65280) shr 8)

        inc(i)

        result[i] = uint8(b and 255)

        inc(i)

    if i > 16:
      raise newException(ValueError, "Invalid IPv6.")
    elif i < 16:
      if iNullPart > -1:
        if i < 4:
          raise newException(ValueError, "Invalid IPv6.")
        elif 0 != x:
          a = i - 1
          i = 15

          while a > iNullPart:
            swap(result[a], result[i])

            dec(a)
            dec(i)

            swap(result[a], result[i])

            dec(a)
            dec(i)

      else:
        raise newException(ValueError, "Invalid IPv6.")

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

proc ipv6ToString*(ip: Ipv6, mode: Ipv6Mode = Ipv6Compressed): string =
  ## Returns an expanded IPv6 textual representation of ``ip``.
  const hexDigits = "0123456789abcdef"

  result = newStringOfCap(45)

  case mode
  of Ipv6Compressed:
    var
      groupZeros = (ii: -1, fi: -1, count: 0)
      bestGroupZeros = (ii: -1, fi: -1, count: 0)

    for i in countup(0, 14, 2):
      let group = (uint16(ip[i]) shl 8) or uint16(ip[i + 1])

      if 0'u16 == group:
        add(result, '0')

        if -1 == groupZeros.ii:
          groupZeros.ii = high(result)

        inc(groupZeros.count)
      else:
        groupZeros = (ii: -1, fi: -1, count: 0)

        var
          leadingZeros = true
          mask = 61440'u16

        for i in countdown(3,0):
          let fourBits = (group and mask) shr (i * 4)

          if fourBits == 0'u16:
            if false == leadingZeros:
              add(result, '0')
          else:
            add(result, hexDigits[fourBits])
            leadingZeros = false

          mask = mask shr 4

      if i < 14:
        add(result, ':')

      if groupZeros.count > bestGroupZeros.count:
        groupZeros.fi = high(result)
        bestGroupZeros = groupZeros

    if 8 == bestGroupZeros.count:
      result = "::"
    elif bestGroupZeros.count > 1:

      if bestGroupZeros.ii == 0:
        result[0] = ':'

        delete(result, 1 .. (bestGroupZeros.fi - 1))
      else:
        result[bestGroupZeros.ii] = ':'

        delete(result, (bestGroupZeros.ii + 1) .. bestGroupZeros.fi)

  of Ipv6LeadingZeros:
    for i in countup(0, 14, 2):
      let group = (uint16(ip[i]) shl 8) or uint16(ip[i + 1])

      if 0'u16 == group:
        add(result, '0')
      else:
        var
          leadingZeros = true
          mask = 61440'u16

        for i in countdown(3,0):
          let fourBits = (group and mask) shr (i * 4)

          if fourBits == 0'u16:
            if false == leadingZeros:
              add(result, '0')
          else:
            add(result, hexDigits[fourBits])
            leadingZeros = false

          mask = mask shr 4

      if i < 14:
        add(result, ':')

  of Ipv6Expanded:
    for i in countup(0, 14, 2):
      let group = (uint16(ip[i]) shl 8) or uint16(ip[i + 1])

      var mask = 61440'u16

      for i in countdown(3,0):
        add(result, hexDigits[(group and mask) shr (i * 4)])

        mask = mask shr 4

      if i < 14:
        add(result, ':')

proc `$`*(ip: Ipv6): string =
  ipv6ToString(ip)

proc cmp*(a, b: Ipv6): int =
  ## Compares IPv6 ``a`` with ``b`` and returns:
  ## * ``0``, if ``a`` is equal to ``b``;
  ## * ``1``, if ``a`` is greater than ``b``; or
  ## * ``-1``, if ``a`` is less than ``b``.
  for i in 0 .. 15:
    if a[i] == b[i]:
      continue
    elif a[i] < b[i]:
      return -1
    else:
      return 1
  return 0
