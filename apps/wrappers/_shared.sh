function run_wrapper {
  local executable="$1"
  local defaultPrintText="$2"
  local defaultPrintFile="$3"
  local overridePrintFileName="$4"
  shift 4

  # Require either defaultPrintText or defaultPrintFile
  if [ -z "$defaultPrintText" ] && [ -z "$defaultPrintFile" ]; then
    echo "run_wrapper: either defaultPrintText or defaultPrintFile must be provided" >&2
    return 1
  fi

  # Prefer override file if present in current directory
  local print_path=""
  if [ -n "$overridePrintFileName" ] && [ -e "./$overridePrintFileName" ]; then
    print_path="./$overridePrintFileName"
  else
    if [ -n "$defaultPrintFile" ]; then
      print_path="$defaultPrintFile"
    fi
  fi

  if [ -n "$print_path" ]; then
    # Decide whether to use imgcat (for images) or cat (for text/others)
    local mime=""
    mime=$(file --mime-type -b "$print_path" 2>/dev/null)

    if [[ "$mime" == image/* || "$print_path" == *.svg ]]; then
      imgcat "$print_path"
    else
      cat "$print_path"
    fi
  else
    printf "%s\n" "$defaultPrintText"
  fi

  # If there are args, run the executable with them
  if [ $# -gt 0 ] && [ -n "$executable" ]; then
    "$executable" "$@"
  fi
}
