docker() {
  if ! command docker ps 1>/dev/null 2>/dev/null; then
    open -ga "Docker.app";
    wait_for_docker
  fi

  if [ $# -eq 0 ]; then
    echo "Docker is running"
  else
    command docker $@
  fi
}
