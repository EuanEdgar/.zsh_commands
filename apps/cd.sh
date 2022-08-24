cd(){
  builtin cd "$@"
  exit_code=$?

  if [ $exit_code = 0 ]; then
    set_folder_colour
    set_node_version
  fi

  return $exit_code
}
