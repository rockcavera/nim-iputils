# Std imports
import std/bitops

# Internal imports
import ./ipv4, ./ipv6

type
  Cidr4* = object
    ip*: Ipv4
    prefix*: range[0'u8 .. 32'u8]

  Cidr6* = object
    ip*: Ipv6
    prefix*: range[0'u8 .. 128'u8]

proc rangeToCidr8[T: Cidr4|Cidr6](a, b: uint8, x: int): seq[T] =
  var
    a = int(a)
    b = int(b)
  
  inc(b)

  while a < b:
    var
      cidr: T
      i = 0
      n = 1
    
    while 0 == (n and a):
      inc(i)

      n = n shl 1

      if i >= 8:
        break
    
    while i > 0 and (n + a) > b:
      dec(i)

      n = n shr 1
    
    cidr.ip[x] = uint8(a)

    cidr.prefix = uint8(8 - i)
    
    add(result, cidr)

    inc(a, n)

template rangeToCidr(T: typedesc[Cidr4|Cidr6]) =
  var
    a = startIp[x]
    b = endIp[x]
  
  if iLimit == x:
    return rangeToCidr8[T](a, b, iLimit)

  let y = x + 1

  if a == b:
    when sizeof(T) == 5:
      result = ipv4RangeToCidrHelp(startIp, endIp, y)
    elif sizeof(T) == 17:
      result = ipv6RangeToCidrHelp(startIp, endIp, y)

    for i in 0 .. high(result):
      result[i].ip[x] = a
      
      result[i].prefix += 8'u8
    
    return result

  var
    start0 = true
    end255 = true
  
  for i in countup(y, iLimit):
    if 0'u8 != startIp[i]:
      start0 = false
      
      break
  
  for i in countup(y, iLimit):
    if 255'u8 != endIp[i]:
      end255 = false

      break
  
  if not(start0):
    var endIp255: typeof(endIp)

    for i in countup(y, iLimit):
      endIp255[i] = 255'u8
    
    when sizeof(T) == 5:
      result = ipv4RangeToCidrHelp(startIp, endIp255, y)
    elif sizeof(T) == 17:
      result = ipv6RangeToCidrHelp(startIp, endIp255, y)

    for i in 0 .. high(result):
      result[i].ip[x] = a
      
      result[i].prefix += 8'u8
    
    inc(a)
  
  if not(end255):
    var startIp0: typeof(startIp)

    for i in countup(y, iLimit):
      startIp0[i] = 0'u8
    
    when sizeof(T) == 5:
      var c = ipv4RangeToCidrHelp(startIp0, endIp, y)
    elif sizeof(T) == 17:
      var c = ipv6RangeToCidrHelp(startIp0, endIp, y)
    
    for i in 0 .. high(c):
      c[i].ip[x] = b

      c[i].prefix += 8'u8
    
    add(result, c)

    dec(b)
  
  if a <= b:
    add(result, rangeToCidr8[T](a, b, x))

proc ipv4RangeToCidrHelp(startIp, endIp: Ipv4, x = 0): seq[Cidr4] =
  const iLimit = 3

  rangeToCidr(Cidr4)

proc ipv4RangeToCidr*(startIp, endIp: Ipv4): seq[Cidr4] =
  ## Returns a ``seq[Cidr4]`` with the CIDR blocks resulting from the IPv4 interval between ``startIp`` and ``endIp``.
  ipv4RangeToCidrHelp(startIp, endIp)

proc ipv6RangeToCidrHelp(startIp, endIp: Ipv6, x = 0): seq[Cidr6] =
  const iLimit = 15

  rangeToCidr(Cidr6)

proc ipv6RangeToCidr*(startIp, endIp: Ipv6): seq[Cidr6] =
  ## Returns a ``seq[Cidr6]`` with the CIDR blocks resulting from the IPv6 interval between ``startIp`` and ``endIp``.
  ipv6RangeToCidrHelp(startIp, endIp)

template cidrToRange() =
  var
    x = 0
    ip = cidr.ip
    prefix = cidr.prefix

  while true:
    if 0'u8 == prefix:
      for i in countup(x, iLimit):
        result.startIp[i] = 0'u8

        result.endIp[i] = 255'u8
      
      return result

    if 8'u8 <= prefix:
      result.startIp[x] = ip[x]
      
      result.endIp[x] = ip[x]

      dec(prefix, 8)

      inc(x)

      continue

    for i in countup(x, iLimit):
      result.startIp[i] = 0'u8

      result.endIp[i] = 255'u8

    let n = (1'u8 shl (8'u8 - prefix)) -  1'u8

    result.startIp[x] = ip[x] and (n xor 255'u8)
    
    result.endIp[x] = result.startIp[x] + n

    return result

proc cidrToIpv4Range*(cidr: Cidr4): tuple[startIp, endIp: Ipv4] =
  ## Returns a tuple with the ``startIp`` and ``endIp`` range of a CIDR block.
  const iLimit = 3

  cidrToRange()

proc cidrToIpv6Range*(cidr: Cidr6): tuple[startIp, endIp: Ipv6] =
  ## Returns a tuple with the ``startIp`` and ``endIp`` range of a CIDR block.
  const iLimit = 15
  
  cidrToRange()

template listAllCidrContainIp(h: uint8) =
  var ip = ip

  for prefix in countdown(h, 0'u8):
    clearBit(ip[prefix div 8], 7'u8 - (prefix mod 8))

    when 4 == sizeof(ip):
      when declared(result):
        add(result, Cidr4(ip: ip, prefix: prefix))
      else:
        yield Cidr4(ip: ip, prefix: prefix)
    elif 16 == sizeof(ip):
      when declared(result):
        add(result, Cidr6(ip: ip, prefix: prefix))
      else:
        yield Cidr6(ip: ip, prefix: prefix)

proc listAllCidrContainIpv4*(ip: Ipv4): seq[Cidr4] =
  ## Returns a ``seq[Cidr4]`` with all 33 CIDR blocks containing the ``ip``.
  add(result, Cidr4(ip: ip, prefix: 32'u8))

  listAllCidrContainIp(31'u8)

proc listAllCidrContainIpv6*(ip: Ipv6): seq[Cidr6] =
  ## Returns a ``seq[Cidr6]`` with all 129 CIDR blocks containing the ``ip``.
  add(result, Cidr6(ip: ip, prefix: 128'u8))

  listAllCidrContainIp(127'u8)

proc cidrToString*(cidr: Cidr4|Cidr6): string =
  ## Returns an CIDR textual representation of ``cidr``.
  when 5 == sizeof(cidr):
    result = newStringOfCap(18)

    add(result, ipv4ToString(cidr.ip))
    add(result, "/")
    add(result, $cidr.prefix)
  elif 17 == sizeof(cidr):
    result = newStringOfCap(49)

    add(result, ipv6ToString(cidr.ip))
    add(result, "/")
    add(result, $cidr.prefix)

proc `$`*(cidr: Cidr4|Cidr6): string =
  cidrToString(cidr)

iterator cidrContainIpv4*(ip: Ipv4): Cidr4 =
  ## Iterate over all 33 CIDR blocks containing the ``ip``.
  yield Cidr4(ip: ip, prefix: 32'u8)

  listAllCidrContainIp(31'u8)

iterator cidrContainIpv6*(ip: Ipv6): Cidr6 =
  ## Iterate over all 129 CIDR blocks containing the ``ip``.
  yield Cidr6(ip: ip, prefix: 128'u8)

  listAllCidrContainIp(127'u8)

proc contains*(cidr: Cidr4, ip: Ipv4): bool =
  ## Returns `true` if `ip` is in `cidr` or `false` if not.
  let
    (startIp, endIp) = cidrToIpv4Range(cidr)
    cmpStart = cmp(startIp, ip)

  cmpStart == 0 or (cmpStart == -1 and cmp(endIp, ip) > -1)

proc contains*(cidr: Cidr6, ip: Ipv6): bool =
  ## Returns `true` if `ip` is in `cidr` or `false` if not.
  let
    (startIp, endIp) = cidrToIpv6Range(cidr)
    cmpStart = cmp(startIp, ip)

  cmpStart == 0 or (cmpStart == -1 and cmp(endIp, ip) > -1)
