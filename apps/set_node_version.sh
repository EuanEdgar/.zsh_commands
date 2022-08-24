set_node_version(){
  if [[ "$NVM_ACTIVE" != "1" || ! -z "$FOLDER_NODE_VERSION" ]]; then
    use_folder_node_version
  fi
}

use_folder_node_version() {
  version_file=$(reverse_find_file '.node-version')

  if [ -s "$version_file" ]; then
    version=$(< $version_file)

    if [[ $version != $FOLDER_NODE_VERSION ]]; then
      nvm use $version
      FOLDER_NODE_VERSION=$version
      return $?
    fi
  fi
}

rename_function nvm _nvm
nvm() {
  NVM_ACTIVE=1
  unset FOLDER_NODE_VERSION
  _nvm "$@"
  return $?
}

reset_node_version() {
  unset NVM_ACTIVE
}
