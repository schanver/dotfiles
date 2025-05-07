function conky_parse_agenda()
  local f = io.open(os.getenv("HOME") .. "/.agenda", "r")
  if not f then return "" end
  local content = f:read("*all")
  f:close()
  return conky_parse(content)
end
