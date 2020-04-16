proc toHex*(x: SomeInteger, fill = false): string =
  const hex = "0123456789abcdef"

  result = newString(4)

  var
    x = x
    y = 3

  while true:
    result[y] = hex[x mod 16]

    x = x div 16

    dec(y)

    if x == 0:
      break
  
  if fill:
    while y > -1:
      result[y] = '0'

      dec(y)
  
  else:
    return result[(y + 1) .. 3]