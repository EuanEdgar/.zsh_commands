docker() {
  if command docker ps 2>/dev/null; then
    command docker $@
  else
    open -a "Docker.app";
    wait_for_docker
    command docker $@
  fi
}