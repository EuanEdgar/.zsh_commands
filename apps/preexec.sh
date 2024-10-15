preexec() {
  command=$1

  temp_colour(){
    colour $@
    export RESET_COLOUR=true
  }

  match(){
    [[ $1 =~ $2 ]]
  }

  if match $command '^(be )?(rails s|foreman start)'; then
    temp_colour red
  elif match $command '^(be )?rails c'; then
    temp_colour orange
  elif match $command '^yarn start(\s|$)'; then
    temp_colour blue
  elif match $command '^yarn dev(\s|$)'; then
    temp_colour blue
  elif match $command '^ssh\s'; then
    temp_colour purple
    set_status ssh prompt
  elif match $command '^(sudo )?(php -S .*|devserve [0-9]+)$'; then
    temp_colour magenta
  elif match $command '^yarn proxy'; then
    temp_colour '#f2ee00'
  fi

  # case $1 in
  #   '(be )?rails s');&
  #   '(be )?foreman start*')
  #     temp_colour red;;
  #   '(be )?rails c')
  #     temp_colour orange;;
  #   'yarn start')
  #     temp_colour blue;;
  #   *)
  #     if [[ $1 =~ "^ssh *" ]]; then
  #       temp_colour purple
  #       set_status ssh 'prompt'
  #     fi
  # esac
}
