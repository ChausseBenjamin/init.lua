((fenced_code_block
  (info_string
    (language) @_lang)) @fold
  (#lua-match? @_lang "^[Mm]ermaid$")
  (#trim! @fold))
