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
/// A slice of a string.
/// TODO: make it a monad
priv struct StringSlice {
  string : String
  start : Int
  end : Int
}

///|
fn slice(s : String, start : Int, end : Int) -> StringSlice {
  { string: s, start, end }
}

///|
fn full_slice(s : String) -> StringSlice {
  slice(s, 0, s.length())
}

///|
fn subfix_unchecked(self : StringSlice, start : Int) -> StringSlice {
  { string: self.string, start: self.start + start, end: self.end }
}

///|
fn first_is(self : StringSlice, c : Char) -> Bool {
  self.length() > 0 && self[0] == c
}

///|
fn first_is_either(self : StringSlice, c1 : Char, c2 : Char) -> Bool {
  self.length() > 0 && (self[0] == c1 || self[0] == c2)
}

///|
fn first_is_digit(self : StringSlice) -> Bool {
  self.length() > 0 && is_digit(self[0])
}

///|
/// Step over `step` non-underscore characters.
/// Return None if there are not enough characters.
fn step(self : StringSlice, step : Int) -> StringSlice? {
  let c = self
  let mut step = step
  let mut start = c.start
  while start < c.end && step > 0 {
    if c.string.unsafe_charcode_at(start) != '_' {
      step -= 1
    }
    start += 1
  }
  if step == 0 {
    Some(c.subfix_unchecked(start - c.start))
  } else {
    None
  }
}

///|
/// Step over the first character without checking.
fn step_1_unchecked(self : StringSlice) -> StringSlice {
  { string: self.string, start: self.start + 1, end: self.end }
}

///|
/// Unsafe: make sure index is in bounds
fn op_get(self : StringSlice, index : Int) -> Char {
  self.string.unsafe_charcode_at(self.start + index).unsafe_to_char()
}

///|
fn length(self : StringSlice) -> Int {
  self.end - self.start
}

///|
fn is_empty(self : StringSlice) -> Bool {
  self.start == self.end
}

///|
fn prefix_eq_ignore_case(self : StringSlice, s2 : String) -> Bool {
  let end = if s2.length() < self.length() {
    s2.length()
  } else {
    self.length()
  }
  for i in 0..<end {
    let c1 = self[i]
    let c2 = s2.unsafe_charcode_at(i).unsafe_to_char()
    if lower(c1) != lower(c2) {
      return false
    }
  }
  true
}

///|
fn lower(c : Char) -> Char {
  if 'A' <= c && c <= 'Z' {
    (c.to_int() + 'a'.to_int() - 'A'.to_int()).unsafe_to_char()
  } else {
    c
  }
}

///|
/// Returns the accumulated value, the slice left, and the number of digits consumed.
/// It ignores underscore and stops when a non-digit character is found.
fn[T] fold_digits(
  self : StringSlice,
  init : T,
  f : (Int, T) -> T,
) -> (StringSlice, T, Int) {
  let mut ret = init
  let mut len = 0
  // let len = self.length()
  for i in 0..<self.length() {
    if !(is_digit(self[i]) || self[i] == '_') {
      return (self.subfix_unchecked(i), ret, len)
    }
    if self[i] != '_' {
      len += 1
      ret = f(to_digit(self[i]), ret)
    }
  }
  (self.subfix_unchecked(self.length()), ret, len)
}

///|
test "eq_ignore_case" {
  assert_true(full_slice("nan").prefix_eq_ignore_case("NaN"))
  assert_true(full_slice("inf").prefix_eq_ignore_case("inf"))
  assert_true(full_slice("inf").prefix_eq_ignore_case("Inf"))
}

///|
test "lower" {
  assert_eq(lower('Z'), 'z')
  assert_eq(lower('A'), 'a')
  assert_eq(lower('a'), 'a')
  assert_eq(lower('z'), 'z')
}
