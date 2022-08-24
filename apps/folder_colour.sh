set_folder_colour(){
  colour_file=$(reverse_find_file '.colour')

  if [ -s "$colour_file" ]; then
    colour $(cat $colour_file)
  fi
}
