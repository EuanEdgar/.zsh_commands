set_node_version(){
  if [[ "$NVM_ACTIVE" != "1" || ! -z "$FOLDER_NODE_VERSION" ]]; then
    use_folder_node_version
  fi
}

use_folder_node_version() {
  version_file='.node-version'
  version_dir=$(pwd)
  while [ ! -s $version_file ] ; do
    parent_dir=$(dirname $version_dir)

    version_file="$parent_dir/.node-version"

    [[ $version_dir = / ]] && break

    version_dir=$parent_dir
  done

  if [ -s $version_file ]; then
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
