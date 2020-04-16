import strutils

type
  Ipv4* = array[4, uint8]

proc parseIpv4*(ip: string): Ipv4 =
  ## Parses a IPv4 value contained in ``ip``.
  let byteParts = split(ip, '.')

  if 4 != len(byteParts):
    raise newException(ValueError, "Invalid IPv4.")

  var x = 3

  for b in byteParts:
    try:
      let bytePart = parseUInt(b)

      if bytePart > 255:
        raise newException(ValueError, "Invalid IPv4.")

      result[x] = uint8(bytePart)
    
    except:
      raise newException(ValueError, "Invalid IPv4.")

    dec(x)

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
  cast[uint32](ip)

proc uint32ToIpv4*(ip: uint32): Ipv4 {.inline.} =
  ## Turns a uint32 type into Ipv4.
  cast[Ipv4](ip)

proc ipv4ToString*(ip: Ipv4): string =
  ## Returns an IPv4 textual representation of an ``ip``.
  for i in countdown(3, 1):
    add(result, $ip[i])
    add(result, ".")
  
  add(result, $ip[0])

proc `$`*(ip: Ipv4): string =
  ipv4ToString(ip)