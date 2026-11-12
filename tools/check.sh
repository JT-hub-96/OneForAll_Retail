#!/usr/bin/env bash
# Checks for OneForAll Retail: every file in the .toc exists, compiles with Lua 5.1 (luac -p) and passes luacheck.
# Needs lua5.1 (luac5.1 or luac) and luacheck. Run from anywhere: tools/check.sh
set -u
cd "$(dirname "$0")/.."
TOC=OneForAll/OneForAll.toc
LUAC=$(command -v luac5.1 || command -v luac)
fail=0
files=()
while IFS= read -r line; do
  line=${line%$'\r'}
  [[ -z "$line" || "$line" == \#* ]] && continue
  f="OneForAll/${line//\\//}"
  if [[ ! -f "$f" ]]; then echo "MISSING: $f (listed in $TOC)"; fail=1; continue; fi
  files+=("$f")
done < "$TOC"
echo "TOC: ${#files[@]} files found"
for f in "${files[@]}"; do
  case "$f" in *.lua) "$LUAC" -p "$f" || fail=1 ;; esac
done
echo "luac -p: done"
luacheck --no-color -q "${files[@]}" || fail=1
[[ $fail -eq 0 ]] && echo "ALL OK" || echo "CHECK FAILED"
exit $fail
