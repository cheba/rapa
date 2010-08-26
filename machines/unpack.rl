// vim: filetype=ragel

%%{

  machine unpack;

  include "unpack_actions.rl";

  ignored = (space | 0)*;

  count = digit >start_digit digit* @count;

  count_modifier    = '*' %rest | count?;
  modifier          = count_modifier | [_!] @non_native_error;
  platform_modifier = ([_!] %platform)? count_modifier;

  # Integers
  S = ('S' platform_modifier) %short_width %set_stop %S %extra;
  s = ('s' platform_modifier) %short_width %set_stop %s %extra;
  I = ('I' platform_modifier) %int_width %set_stop %I %extra;
  i = ('i' platform_modifier) %int_width %set_stop %i %extra;
  L = ('L' platform_modifier) %platform_width %set_stop %L %extra;
  l = ('l' platform_modifier) %platform_width %set_stop %l %extra;

  C = ('C' modifier) %byte_width %set_stop %C %extra;
  c = ('c' modifier) %byte_width %set_stop %c %extra;
  N = ('N' modifier) %int_width %set_stop %N %extra;
  n = ('n' modifier) %short_width %set_stop %n %extra;
  V = ('V' modifier) %int_width %set_stop %V %extra;
  v = ('v' modifier) %short_width %set_stop %v %extra;
  Q = ('Q' modifier) %long_width %set_stop %Q %extra;
  q = ('q' modifier) %long_width %set_stop %q %extra;

  # Floats
  D = (('D' | 'd') modifier) %long_width %set_stop %D %extra;
  E = ('E'         modifier) %long_width %set_stop %E %extra;
  e = ('e'         modifier) %int_width %set_stop %e %extra;
  F = (('F' | 'f') modifier) %int_width %set_stop %F %extra;
  G = ('G'         modifier) %long_width %set_stop %G %extra;
  g = ('g'         modifier) %int_width %set_stop %g %extra;

  # Moves
  X  = ('X' modifier) %X %check_bounds;
  x  = ('x' modifier) %x %check_bounds;
  at = ('@' >zero_count modifier) %at %check_bounds;

  # Strings
  A = ('A' modifier) %byte_address %string_size %A;
  a = ('a' modifier) %byte_address %string_size %a;
  Z = ('Z' modifier) %byte_address %string_size %Z;

  integers  = C | c | S | s | I | i | L | l | N | n | V | v | Q | q;
  floats    = D | E | e | F | G | g;
  strings   = A | a | Z;
  moves     = X | x | at;

  directives = integers | strings | moves | floats;

  main := (directives >start ignored)+ %done;

  write data;
  write init;
  write exec;

}%%
