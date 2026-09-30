function folder_commands {
  dot_cd=$(reverse_find_file '.cd')

  if [ -s "$dot_cd" ]; then
    source "$dot_cd"
  fi
}

chpwd_functions+=set_folder_colour
chpwd_functions+=set_node_version
chpwd_functions+=set_folder_tab_name
chpwd_functions+=folder_commands
