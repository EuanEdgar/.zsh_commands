set_folder_tab_name() {
  tab_name=""
  tab_name_prefix_file=$(reverse_find_file '.tab-name-prefix')
  tab_name_file=$(reverse_find_file '.tab-name')

  if [[ -s $tab_name_prefix_file ]]; then
    if [[ ! -s ./.tab-name-prefix || -s $tab_name_file ]]; then
      tab_name=$(<$tab_name_prefix_file)
    fi
  fi

  if [[ -s $tab_name_file ]]; then
    tab_name+="$(<$tab_name_file)"
  elif git_root=$(git rev-parse --show-toplevel 2>/dev/null); then
    tab_name+="$(basename "$git_root")"
  else
    tab_name+="$(pretty_pwd)"
  fi

  export TAB_NAME=$tab_name
}
