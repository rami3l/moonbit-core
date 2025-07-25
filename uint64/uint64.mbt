// Copyright 2025 International Digital Economy Academy
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

///|
pub let min_value : UInt64 = 0UL

///|
pub let max_value : UInt64 = 18446744073709551615UL

///| Converts the UInt64 to a Bytes in big-endian byte order.
pub fn to_be_bytes(self : UInt64) -> Bytes {
  [
    (self >> 56).to_byte(),
    (self >> 48).to_byte(),
    (self >> 40).to_byte(),
    (self >> 32).to_byte(),
    (self >> 24).to_byte(),
    (self >> 16).to_byte(),
    (self >> 8).to_byte(),
    self.to_byte(),
  ]
}

///| Converts the UInt64 to a Bytes in little-endian byte order.
pub fn to_le_bytes(self : UInt64) -> Bytes {
  [
    self.to_byte(),
    (self >> 8).to_byte(),
    (self >> 16).to_byte(),
    (self >> 24).to_byte(),
    (self >> 32).to_byte(),
    (self >> 40).to_byte(),
    (self >> 48).to_byte(),
    (self >> 56).to_byte(),
  ]
}

///|
test "to_be_bytes" {
  inspect(
    max_value.to_be_bytes(),
    content=(
      #|b"\xff\xff\xff\xff\xff\xff\xff\xff"
    ),
  )
  inspect(
    min_value.to_be_bytes(),
    content=(
      #|b"\x00\x00\x00\x00\x00\x00\x00\x00"
    ),
  )
  inspect(
    0x123456789ABCDEF0UL.to_be_bytes(),
    content=(
      #|b"\x12\x34\x56\x78\x9a\xbc\xde\xf0"
    ),
  )
}

///|
test "to_le_bytes" {
  inspect(
    max_value.to_le_bytes(),
    content=(
      #|b"\xff\xff\xff\xff\xff\xff\xff\xff"
    ),
  )
  inspect(
    min_value.to_le_bytes(),
    content=(
      #|b"\x00\x00\x00\x00\x00\x00\x00\x00"
    ),
  )
  inspect(
    0x123456789ABCDEF0UL.to_le_bytes(),
    content=(
      #|b"\xf0\xde\xbc\x9a\x78\x56\x34\x12"
    ),
  )
}
