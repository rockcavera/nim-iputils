import unittest

import iputils

suite "IPv4 tests":
  test "parseIpv4":
    check parseIpv4("0.0.0.0") == Ipv4([0'u8, 0, 0, 0])
    check parseIpv4("1.2.3.4") == Ipv4([1'u8, 2, 3, 4])
    check parseIpv4("255.255.255.255") == Ipv4([255'u8, 255, 255, 255])
  
  test "isIpv4AndStore":
    var sipv4: Ipv4

    check isIpv4AndStore("0.0.0.0", sipv4) == true and sipv4 == Ipv4([0'u8, 0, 0, 0])
    check isIpv4AndStore("1.2.3.4", sipv4) == true and sipv4 == Ipv4([1'u8, 2, 3, 4])
    check isIpv4AndStore("255.255.255.255", sipv4) == true and sipv4 == Ipv4([255'u8, 255, 255, 255])

    check isIpv4AndStore("", sipv4) == false
    check isIpv4AndStore("0.0.0", sipv4) == false
    check isIpv4AndStore("0.0.0.0.0", sipv4) == false
    check isIpv4AndStore("256.256.256.256", sipv4) == false
    check isIpv4AndStore("-1.-2.-3.-4", sipv4) == false
    check isIpv4AndStore("a.b.c.d", sipv4) == false
    check isIpv4AndStore("::", sipv4) == false
  
  test "isIpv4":
    check isIpv4("0.0.0.0") == true
    check isIpv4("1.2.3.4") == true
    check isIpv4("255.255.255.255") == true

    check isIpv4("") == false
    check isIpv4("0.0.0") == false
    check isIpv4("0.0.0.0.0") == false
    check isIpv4("256.256.256.256") == false
    check isIpv4("-1.-2.-3.-4") == false
    check isIpv4("a.b.c.d") == false
    check isIpv4("::") == false
  
  test "ipv4ToUInt32":
    check ipv4ToUInt32(Ipv4([0'u8, 0, 0, 0])) == 0'u32
    check ipv4ToUInt32(Ipv4([1'u8, 2, 3, 4])) == 16909060'u32
    check ipv4ToUInt32(Ipv4([255'u8, 255, 255, 255])) == 4294967295'u32
  
  test "uint32ToIpv4":
    check uint32ToIpv4(0'u32) == Ipv4([0'u8, 0, 0, 0])
    check uint32ToIpv4(16909060'u32) == Ipv4([1'u8, 2, 3, 4])
    check uint32ToIpv4(4294967295'u32) == Ipv4([255'u8, 255, 255, 255])

  test "ipv4ToString":
    check ipv4ToString(Ipv4([0'u8, 0, 0, 0])) == "0.0.0.0"
    check ipv4ToString(Ipv4([1'u8, 2, 3, 4])) == "1.2.3.4"
    check ipv4ToString(Ipv4([255'u8, 255, 255, 255])) == "255.255.255.255"

  test "cmp":
    check cmp(Ipv4([0'u8, 0, 0, 0]), Ipv4([0'u8, 0, 0, 0])) == 0
    check cmp(Ipv4([0'u8, 0, 0, 0]), Ipv4([1'u8, 2, 3, 4])) == -1
    check cmp(Ipv4([0'u8, 0, 0, 0]), Ipv4([255'u8, 255, 255, 255])) == -1
    check cmp(Ipv4([1'u8, 2, 3, 4]), Ipv4([0'u8, 0, 0, 0])) == 1
    check cmp(Ipv4([1'u8, 2, 3, 4]), Ipv4([1'u8, 2, 3, 4])) == 0
    check cmp(Ipv4([1'u8, 2, 3, 4]), Ipv4([255'u8, 255, 255, 255])) == -1
    check cmp(Ipv4([255'u8, 255, 255, 255]), Ipv4([0'u8, 0, 0, 0])) == 1
    check cmp(Ipv4([255'u8, 255, 255, 255]), Ipv4([1'u8, 2, 3, 4])) == 1
    check cmp(Ipv4([255'u8, 255, 255, 255]), Ipv4([255'u8, 255, 255, 255])) == 0