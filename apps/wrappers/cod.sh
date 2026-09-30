source "$COMMANDS_PATH/apps/wrappers/_shared.sh"

function cod() {
  read -r -d '' fish <<- 'EOF'
		Glub      /\
		  glub# _/./
		    ,-'    `-:..-'/
		    : o )      _  (
		    "`-....,--; `-.\
		        `'
EOF

  local to_print
  if [ $# -eq 0 ]; then
    to_print="$(printf "%s" "$fish" | tr '#' '?')"
  else
    to_print="$(printf "%s" "$fish" | tr '#' ' ')"
  fi

  run_wrapper "code" "$to_print" "" ".fishy" "$@"
}
