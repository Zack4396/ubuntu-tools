#!/bin/bash

usage() {
  cat <<EOF
Usage: $0 --install_path

EOF
}

install_youcompleteme() {
  local my_install_path="$(realpath $1)"

  # Check
  command -v cmake > /dev/null 2>&1
  if ! [[ "$?" == "0" ]]; then
    echo "Please install cmake:"
    echo "$ sudo apt-get install cmake"
    exit 1
  fi

  command -v doxygen > /dev/null 2>&1
  if ! [[ "$?" == "0" ]]; then
    echo "Please install doxygen:"
    echo "$ sudo apt-get install doxygen"
    exit 1
  fi

  if ! [[ -d $my_install_path ]]; then
    echo "$my_install_path is not exist"
    exit 1
  fi

  pushd $my_install_path

  chmod +x ./install.sh
  ./install.sh --clang-completer --system-libclang

  mkdir -p $my_install_path/cpp/ycm
  cp $my_install_path/third_party/ycmd/examples/.ycm_extra_conf.py $my_install_path/cpp/ycm/

  popd
}

main() {
  if [ "$BASH_SOURCE" == "$0" ]; then
    set -e
    if [ "$#" -lt "2" ]; then
      usage "$@"
      exit 1
    else
      local install_path=""
      while [[ $# -gt 0 ]]; do
        key="$1"

        case $key in
          --install_path)
            install_path="$2"
            shift 2
            ;;
          *)
            echo "Unknown: $1"
            exit 1
            ;;
        esac
      done
      install_youcompleteme "$install_path"
    fi
  else
    echo "Please run $BASH_SOURCE without source"
  fi
}

main "$@"
