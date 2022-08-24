reverse_find_file(){
  target_file_name=$1

  target_file="./$target_file_name"

  test_dir=$(pwd)

  while [ ! -s $target_file ] ; do
    parent_dir=$(dirname $test_dir)

    target_file="$parent_dir/$target_file_name"

    [[ $test_dir = / ]] && break

    test_dir=$parent_dir
  done

  if [ -s $target_file ]; then
    echo $target_file
  fi
}
