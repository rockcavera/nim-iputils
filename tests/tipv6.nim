import unittest

import iputils

suite "IPv6 tests":
  test "parseIpv6":
    check parseIpv6("::") == Ipv6([0'u8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    check parseIpv6("::8") == Ipv6([0'u8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8])
    check parseIpv6("::2:3:4:5:6:7:8") == Ipv6([0'u8, 0, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8])
    check parseIpv6("1::") == Ipv6([0'u8, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    check parseIpv6("1::8") == Ipv6([0'u8, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8])
    check parseIpv6("1::7:8") == Ipv6([0'u8, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 8])
    check parseIpv6("1::6:7:8") == Ipv6([0'u8, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 7, 0, 8])
    check parseIpv6("1::5:6:7:8") == Ipv6([0'u8, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 6, 0, 7, 0, 8])
    check parseIpv6("1::4:5:6:7:8") == Ipv6([0'u8, 1, 0, 0, 0, 0, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8])
    check parseIpv6("1::3:4:5:6:7:8") == Ipv6([0'u8, 1, 0, 0, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8])
    check parseIpv6("1:2::8") == Ipv6([0'u8, 1, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8])
    check parseIpv6("1:2::4:5:6:7:8") == Ipv6([0'u8, 1, 0, 2, 0, 0, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8])
    check parseIpv6("1:2:3::8") == Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8])
    check parseIpv6("1:2:3::5:6:7:8") == Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 0, 0, 5, 0, 6, 0, 7, 0, 8])
    check parseIpv6("1:2:3:4::8") == Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 0, 0, 0, 0, 0, 0, 8])
    check parseIpv6("1:2:3:4::6:7:8") == Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 0, 0, 6, 0, 7, 0, 8])
    check parseIpv6("1:2:3:4:5::8") == Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 0, 0, 0, 0, 8])
    check parseIpv6("1:2:3:4:5::7:8") == Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 0, 0, 7, 0, 8])
    check parseIpv6("1:2:3:4:5:6::8") == Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6, 0, 0, 0, 8])
    check parseIpv6("1:2:3:4:5:6:7::") == Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 0])
    check parseIpv6("1:2:3:4:5:6:7:8") == Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8])
    check parseIpv6("::255.255.255.255") == Ipv6([0'u8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 255, 255])
    check parseIpv6("::ffff:255.255.255.255") == Ipv6([0'u8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 255, 255, 255, 255])
    check parseIpv6("::ffff:0:255.255.255.255") == Ipv6([0'u8, 0, 0, 0, 0, 0, 0, 0, 255, 255, 0, 0, 255, 255, 255, 255])
    check parseIpv6("2001:db8:3:4::192.0.2.33") == Ipv6([32'u8, 1, 13, 184, 0, 3, 0, 4, 0, 0, 0, 0, 192, 0, 2, 33])
    check parseIpv6("64:ff9b::192.0.2.33") == Ipv6([0'u8, 100, 255, 155, 0, 0, 0, 0, 0, 0, 0, 0, 192, 0, 2, 33])

  test "isIpv6AndStore":
    var sipv6: Ipv6

    check isIpv6AndStore("::", sipv6) == true and sipv6 == Ipv6([0'u8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    check isIpv6AndStore("::8", sipv6) == true and sipv6 == Ipv6([0'u8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8])
    check isIpv6AndStore("::2:3:4:5:6:7:8", sipv6) == true and sipv6 == Ipv6([0'u8, 0, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8])
    check isIpv6AndStore("1::", sipv6) == true and sipv6 == Ipv6([0'u8, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    check isIpv6AndStore("1::8", sipv6) == true and sipv6 == Ipv6([0'u8, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8])
    check isIpv6AndStore("1::7:8", sipv6) == true and sipv6 == Ipv6([0'u8, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 8])
    check isIpv6AndStore("1::6:7:8", sipv6) == true and sipv6 == Ipv6([0'u8, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 7, 0, 8])
    check isIpv6AndStore("1::5:6:7:8", sipv6) == true and sipv6 == Ipv6([0'u8, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 6, 0, 7, 0, 8])
    check isIpv6AndStore("1::4:5:6:7:8", sipv6) == true and sipv6 == Ipv6([0'u8, 1, 0, 0, 0, 0, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8])
    check isIpv6AndStore("1::3:4:5:6:7:8", sipv6) == true and sipv6 == Ipv6([0'u8, 1, 0, 0, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8])
    check isIpv6AndStore("1:2::8", sipv6) == true and sipv6 == Ipv6([0'u8, 1, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8])
    check isIpv6AndStore("1:2::4:5:6:7:8", sipv6) == true and sipv6 == Ipv6([0'u8, 1, 0, 2, 0, 0, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8])
    check isIpv6AndStore("1:2:3::8", sipv6) == true and sipv6 == Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8])
    check isIpv6AndStore("1:2:3::5:6:7:8", sipv6) == true and sipv6 == Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 0, 0, 5, 0, 6, 0, 7, 0, 8])
    check isIpv6AndStore("1:2:3:4::8", sipv6) == true and sipv6 == Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 0, 0, 0, 0, 0, 0, 8])
    check isIpv6AndStore("1:2:3:4::6:7:8", sipv6) == true and sipv6 == Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 0, 0, 6, 0, 7, 0, 8])
    check isIpv6AndStore("1:2:3:4:5::8", sipv6) == true and sipv6 == Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 0, 0, 0, 0, 8])
    check isIpv6AndStore("1:2:3:4:5::7:8", sipv6) == true and sipv6 == Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 0, 0, 7, 0, 8])
    check isIpv6AndStore("1:2:3:4:5:6::8", sipv6) == true and sipv6 == Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6, 0, 0, 0, 8])
    check isIpv6AndStore("1:2:3:4:5:6:7::", sipv6) == true and sipv6 == Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 0])
    check isIpv6AndStore("1:2:3:4:5:6:7:8", sipv6) == true and sipv6 == Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8])
    check isIpv6AndStore("::255.255.255.255", sipv6) == true and sipv6 == Ipv6([0'u8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 255, 255])
    check isIpv6AndStore("::ffff:255.255.255.255", sipv6) == true and sipv6 == Ipv6([0'u8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 255, 255, 255, 255])
    check isIpv6AndStore("::ffff:0:255.255.255.255", sipv6) == true and sipv6 == Ipv6([0'u8, 0, 0, 0, 0, 0, 0, 0, 255, 255, 0, 0, 255, 255, 255, 255])
    check isIpv6AndStore("2001:db8:3:4::192.0.2.33", sipv6) == true and sipv6 == Ipv6([32'u8, 1, 13, 184, 0, 3, 0, 4, 0, 0, 0, 0, 192, 0, 2, 33])
    check isIpv6AndStore("64:ff9b::192.0.2.33", sipv6) == true and sipv6 == Ipv6([0'u8, 100, 255, 155, 0, 0, 0, 0, 0, 0, 0, 0, 192, 0, 2, 33])

    check isIpv6AndStore("", sipv6) == false
    check isIpv6AndStore(":", sipv6) == false
    check isIpv6AndStore(":::", sipv6) == false
    check isIpv6AndStore("1:2", sipv6) == false
    check isIpv6AndStore("1:2:3", sipv6) == false
    check isIpv6AndStore("1:2:3:4", sipv6) == false
    check isIpv6AndStore("1:2:3:4:5", sipv6) == false
    check isIpv6AndStore("1:2:3:4:5:6", sipv6) == false
    check isIpv6AndStore("1:2:3:4:5:6:7", sipv6) == false
    check isIpv6AndStore("1:2:3:4:5:6:7:", sipv6) == false
    check isIpv6AndStore("1:2:3:4:5:6:7:8:9", sipv6) == false
    check isIpv6AndStore("1:2:3:4:5:6:7:8:", sipv6) == false
    check isIpv6AndStore("1:2:3:4:5:6:7:8::", sipv6) == false
    check isIpv6AndStore("::2:3:4:5:6:7:8:9", sipv6) == false
    check isIpv6AndStore("1::2::", sipv6) == false
    check isIpv6AndStore("::1::2", sipv6) == false
    check isIpv6AndStore("::1:2::", sipv6) == false
    check isIpv6AndStore(":1.2.3.4", sipv6) == false
    check isIpv6AndStore("1.2.3.4", sipv6) == false
    check isIpv6AndStore("1.2.3.4::", sipv6) == false
    check isIpv6AndStore("::255.255.255.256", sipv6) == false
    check isIpv6AndStore("::1.2.3", sipv6) == false
    check isIpv6AndStore("::1.2.3.4.5", sipv6) == false
    check isIpv6AndStore("::-1.-2.-3.-4", sipv6) == false
    check isIpv6AndStore("::a.b.c.d", sipv6) == false

  test "isIpv6":
    check isIpv6("::") == true
    check isIpv6("::8") == true
    check isIpv6("::2:3:4:5:6:7:8") == true
    check isIpv6("1::") == true
    check isIpv6("1::8") == true
    check isIpv6("1::7:8") == true
    check isIpv6("1::6:7:8") == true
    check isIpv6("1::5:6:7:8") == true
    check isIpv6("1::4:5:6:7:8") == true
    check isIpv6("1::3:4:5:6:7:8") == true
    check isIpv6("1:2::8") == true
    check isIpv6("1:2::4:5:6:7:8") == true
    check isIpv6("1:2:3::8") == true
    check isIpv6("1:2:3::5:6:7:8") == true
    check isIpv6("1:2:3:4::8") == true
    check isIpv6("1:2:3:4::6:7:8") == true
    check isIpv6("1:2:3:4:5::8") == true
    check isIpv6("1:2:3:4:5::7:8") == true
    check isIpv6("1:2:3:4:5:6::8") == true
    check isIpv6("1:2:3:4:5:6:7::") == true
    check isIpv6("1:2:3:4:5:6:7:8") == true
    check isIpv6("::255.255.255.255") == true
    check isIpv6("::ffff:255.255.255.255") == true
    check isIpv6("::ffff:0:255.255.255.255") == true
    check isIpv6("2001:db8:3:4::192.0.2.33") == true
    check isIpv6("64:ff9b::192.0.2.33") == true

    check isIpv6("") == false
    check isIpv6(":") == false
    check isIpv6(":::") == false
    check isIpv6("1:2") == false
    check isIpv6("1:2:3") == false
    check isIpv6("1:2:3:4") == false
    check isIpv6("1:2:3:4:5") == false
    check isIpv6("1:2:3:4:5:6") == false
    check isIpv6("1:2:3:4:5:6:7") == false
    check isIpv6("1:2:3:4:5:6:7:") == false
    check isIpv6("1:2:3:4:5:6:7:8:9") == false
    check isIpv6("1:2:3:4:5:6:7:8:") == false
    check isIpv6("1:2:3:4:5:6:7:8::") == false
    check isIpv6("::2:3:4:5:6:7:8:9") == false
    check isIpv6("1::2::") == false
    check isIpv6("::1::2") == false
    check isIpv6("::1:2::") == false
    check isIpv6(":1.2.3.4") == false
    check isIpv6("1.2.3.4") == false
    check isIpv6("1.2.3.4::") == false
    check isIpv6("::255.255.255.256") == false
    check isIpv6("::1.2.3") == false
    check isIpv6("::1.2.3.4.5") == false
    check isIpv6("::-1.-2.-3.-4") == false
    check isIpv6("::a.b.c.d") == false

  test "ipv6ToString":
    check ipv6ToString(Ipv6([0'u8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]), Ipv6Compressed) == "::"
    check ipv6ToString(Ipv6([0'u8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8]), Ipv6Compressed) == "::8"
    check ipv6ToString(Ipv6([0'u8, 0, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8]), Ipv6Compressed) == "0:2:3:4:5:6:7:8"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]), Ipv6Compressed) == "1::"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8]), Ipv6Compressed) == "1::8"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 8]), Ipv6Compressed) == "1::7:8"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 7, 0, 8]), Ipv6Compressed) == "1::6:7:8"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 6, 0, 7, 0, 8]), Ipv6Compressed) == "1::5:6:7:8"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 0, 0, 0, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8]), Ipv6Compressed) == "1::4:5:6:7:8"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 0, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8]), Ipv6Compressed) == "1:0:3:4:5:6:7:8"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8]), Ipv6Compressed) == "1:2::8"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 2, 0, 0, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8]), Ipv6Compressed) == "1:2:0:4:5:6:7:8"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8]), Ipv6Compressed) == "1:2:3::8"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 0, 0, 5, 0, 6, 0, 7, 0, 8]), Ipv6Compressed) == "1:2:3:0:5:6:7:8"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 0, 0, 0, 0, 0, 0, 8]), Ipv6Compressed) == "1:2:3:4::8"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 0, 0, 6, 0, 7, 0, 8]), Ipv6Compressed) == "1:2:3:4:0:6:7:8"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 0, 0, 0, 0, 8]), Ipv6Compressed) == "1:2:3:4:5::8"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 0, 0, 7, 0, 8]), Ipv6Compressed) == "1:2:3:4:5:0:7:8"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6, 0, 0, 0, 8]), Ipv6Compressed) == "1:2:3:4:5:6:0:8"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 0]), Ipv6Compressed) == "1:2:3:4:5:6:7:0"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8]), Ipv6Compressed) == "1:2:3:4:5:6:7:8"
    check ipv6ToString(Ipv6([0'u8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 255, 255]), Ipv6Compressed) == "::ffff:ffff"
    check ipv6ToString(Ipv6([0'u8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 255, 255, 255, 255]), Ipv6Compressed) == "::ffff:ffff:ffff"
    check ipv6ToString(Ipv6([0'u8, 0, 0, 0, 0, 0, 0, 0, 255, 255, 0, 0, 255, 255, 255, 255]), Ipv6Compressed) == "::ffff:0:ffff:ffff"
    check ipv6ToString(Ipv6([32'u8, 1, 13, 184, 0, 3, 0, 4, 0, 0, 0, 0, 192, 0, 2, 33]), Ipv6Compressed) == "2001:db8:3:4::c000:221"
    check ipv6ToString(Ipv6([0'u8, 100, 255, 155, 0, 0, 0, 0, 0, 0, 0, 0, 192, 0, 2, 33]), Ipv6Compressed) == "64:ff9b::c000:221"
    check ipv6ToString(Ipv6([0'u8, 0, 0, 0, 0, 3, 0, 4, 0, 0, 0, 0, 0, 0, 0, 8]), Ipv6Compressed) == "0:0:3:4::8"

    check ipv6ToString(Ipv6([0'u8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]), Ipv6LeadingZeros) == "0:0:0:0:0:0:0:0"
    check ipv6ToString(Ipv6([0'u8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8]), Ipv6LeadingZeros) == "0:0:0:0:0:0:0:8"
    check ipv6ToString(Ipv6([0'u8, 0, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8]), Ipv6LeadingZeros) == "0:2:3:4:5:6:7:8"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]), Ipv6LeadingZeros) == "1:0:0:0:0:0:0:0"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8]), Ipv6LeadingZeros) == "1:0:0:0:0:0:0:8"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 8]), Ipv6LeadingZeros) == "1:0:0:0:0:0:7:8"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 7, 0, 8]), Ipv6LeadingZeros) == "1:0:0:0:0:6:7:8"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 6, 0, 7, 0, 8]), Ipv6LeadingZeros) == "1:0:0:0:5:6:7:8"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 0, 0, 0, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8]), Ipv6LeadingZeros) == "1:0:0:4:5:6:7:8"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 0, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8]), Ipv6LeadingZeros) == "1:0:3:4:5:6:7:8"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8]), Ipv6LeadingZeros) == "1:2:0:0:0:0:0:8"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 2, 0, 0, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8]), Ipv6LeadingZeros) == "1:2:0:4:5:6:7:8"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8]), Ipv6LeadingZeros) == "1:2:3:0:0:0:0:8"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 0, 0, 5, 0, 6, 0, 7, 0, 8]), Ipv6LeadingZeros) == "1:2:3:0:5:6:7:8"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 0, 0, 0, 0, 0, 0, 8]), Ipv6LeadingZeros) == "1:2:3:4:0:0:0:8"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 0, 0, 6, 0, 7, 0, 8]), Ipv6LeadingZeros) == "1:2:3:4:0:6:7:8"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 0, 0, 0, 0, 8]), Ipv6LeadingZeros) == "1:2:3:4:5:0:0:8"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 0, 0, 7, 0, 8]), Ipv6LeadingZeros) == "1:2:3:4:5:0:7:8"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6, 0, 0, 0, 8]), Ipv6LeadingZeros) == "1:2:3:4:5:6:0:8"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 0]), Ipv6LeadingZeros) == "1:2:3:4:5:6:7:0"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8]), Ipv6LeadingZeros) == "1:2:3:4:5:6:7:8"
    check ipv6ToString(Ipv6([0'u8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 255, 255]), Ipv6LeadingZeros) == "0:0:0:0:0:0:ffff:ffff"
    check ipv6ToString(Ipv6([0'u8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 255, 255, 255, 255]), Ipv6LeadingZeros) == "0:0:0:0:0:ffff:ffff:ffff"
    check ipv6ToString(Ipv6([0'u8, 0, 0, 0, 0, 0, 0, 0, 255, 255, 0, 0, 255, 255, 255, 255]), Ipv6LeadingZeros) == "0:0:0:0:ffff:0:ffff:ffff"
    check ipv6ToString(Ipv6([32'u8, 1, 13, 184, 0, 3, 0, 4, 0, 0, 0, 0, 192, 0, 2, 33]), Ipv6LeadingZeros) == "2001:db8:3:4:0:0:c000:221"
    check ipv6ToString(Ipv6([0'u8, 100, 255, 155, 0, 0, 0, 0, 0, 0, 0, 0, 192, 0, 2, 33]), Ipv6LeadingZeros) == "64:ff9b:0:0:0:0:c000:221"

    check ipv6ToString(Ipv6([0'u8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]), Ipv6Expanded) == "0000:0000:0000:0000:0000:0000:0000:0000"
    check ipv6ToString(Ipv6([0'u8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8]), Ipv6Expanded) == "0000:0000:0000:0000:0000:0000:0000:0008"
    check ipv6ToString(Ipv6([0'u8, 0, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8]), Ipv6Expanded) == "0000:0002:0003:0004:0005:0006:0007:0008"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]), Ipv6Expanded) == "0001:0000:0000:0000:0000:0000:0000:0000"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8]), Ipv6Expanded) == "0001:0000:0000:0000:0000:0000:0000:0008"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 8]), Ipv6Expanded) == "0001:0000:0000:0000:0000:0000:0007:0008"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 7, 0, 8]), Ipv6Expanded) == "0001:0000:0000:0000:0000:0006:0007:0008"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 6, 0, 7, 0, 8]), Ipv6Expanded) == "0001:0000:0000:0000:0005:0006:0007:0008"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 0, 0, 0, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8]), Ipv6Expanded) == "0001:0000:0000:0004:0005:0006:0007:0008"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 0, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8]), Ipv6Expanded) == "0001:0000:0003:0004:0005:0006:0007:0008"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8]), Ipv6Expanded) == "0001:0002:0000:0000:0000:0000:0000:0008"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 2, 0, 0, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8]), Ipv6Expanded) == "0001:0002:0000:0004:0005:0006:0007:0008"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8]), Ipv6Expanded) == "0001:0002:0003:0000:0000:0000:0000:0008"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 0, 0, 5, 0, 6, 0, 7, 0, 8]), Ipv6Expanded) == "0001:0002:0003:0000:0005:0006:0007:0008"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 0, 0, 0, 0, 0, 0, 8]), Ipv6Expanded) == "0001:0002:0003:0004:0000:0000:0000:0008"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 0, 0, 6, 0, 7, 0, 8]), Ipv6Expanded) == "0001:0002:0003:0004:0000:0006:0007:0008"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 0, 0, 0, 0, 8]), Ipv6Expanded) == "0001:0002:0003:0004:0005:0000:0000:0008"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 0, 0, 7, 0, 8]), Ipv6Expanded) == "0001:0002:0003:0004:0005:0000:0007:0008"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6, 0, 0, 0, 8]), Ipv6Expanded) == "0001:0002:0003:0004:0005:0006:0000:0008"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 0]), Ipv6Expanded) == "0001:0002:0003:0004:0005:0006:0007:0000"
    check ipv6ToString(Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8]), Ipv6Expanded) == "0001:0002:0003:0004:0005:0006:0007:0008"
    check ipv6ToString(Ipv6([0'u8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 255, 255]), Ipv6Expanded) == "0000:0000:0000:0000:0000:0000:ffff:ffff"
    check ipv6ToString(Ipv6([0'u8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 255, 255, 255, 255]), Ipv6Expanded) == "0000:0000:0000:0000:0000:ffff:ffff:ffff"
    check ipv6ToString(Ipv6([0'u8, 0, 0, 0, 0, 0, 0, 0, 255, 255, 0, 0, 255, 255, 255, 255]), Ipv6Expanded) == "0000:0000:0000:0000:ffff:0000:ffff:ffff"
    check ipv6ToString(Ipv6([32'u8, 1, 13, 184, 0, 3, 0, 4, 0, 0, 0, 0, 192, 0, 2, 33]), Ipv6Expanded) == "2001:0db8:0003:0004:0000:0000:c000:0221"
    check ipv6ToString(Ipv6([0'u8, 100, 255, 155, 0, 0, 0, 0, 0, 0, 0, 0, 192, 0, 2, 33]), Ipv6Expanded) == "0064:ff9b:0000:0000:0000:0000:c000:0221"

  test "cmp":
    check cmp(Ipv6([0'u8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]), Ipv6([0'u8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])) == 0
    check cmp(Ipv6([0'u8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]), Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8])) == -1
    check cmp(Ipv6([0'u8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]), Ipv6([255'u8, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255])) == -1

    check cmp(Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8]), Ipv6([0'u8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])) == 1
    check cmp(Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8]), Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8])) == 0
    check cmp(Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8]), Ipv6([255'u8, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255])) == -1

    check cmp(Ipv6([255'u8, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255]), Ipv6([0'u8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])) == 1
    check cmp(Ipv6([255'u8, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255]), Ipv6([0'u8, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8])) == 1
    check cmp(Ipv6([255'u8, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255]), Ipv6([255'u8, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255])) == 0
