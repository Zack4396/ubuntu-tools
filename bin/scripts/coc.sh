#!/bin/bash

usage() {
  cat <<EOF
Usage: $0 --install_path

EOF
}

install_coc() {
  local my_install_path="$(realpath $1)"

  # Check
  command -v node > /dev/null 2>&1
  if ! [[ "$?" == "0" ]]; then
    echo "Please install node:"
    echo "$ curl -sL https://deb.nodesource.com/setup_16.x -o /tmp/nodesource_setup.sh"
    echo "$ sudo bash /tmp/nodesource_setup.sh"
    echo "$ sudo apt-get install -y nodejs"
    exit 1
  fi

  command -v npm > /dev/null 2>&1
  if ! [[ "$?" == "0" ]]; then
    echo "Please install npm:"
    echo "$ sudo apt-get install npm"
    exit 1
  fi

  command -v yarn > /dev/null 2>&1
  if ! [[ "$?" == "0" ]]; then
    echo "Please install yarn:"
    echo "$ sudo npm install yarn@latest -g --force"
    exit 1
  fi

  command -v semver > /dev/null 2>&1
  if ! [[ "$?" == "0" ]]; then
    echo "Please install yarn:"
    echo "$ sudo npm install semver@latest -g --force"
    exit 1
  fi

  semver -r ">=v16.17" $(node --version) > /dev/null 2>&1
  if ! [[ "$?" == "0" ]]; then
    echo "Please update node:"
    echo "$ curl -sL https://deb.nodesource.com/setup_16.x -o /tmp/nodesource_setup.sh"
    echo "$ sudo bash /tmp/nodesource_setup.sh"
    echo "$ sudo apt-get install -y nodejs"
    exit 1
  fi

  semver -r ">=8.0" $(npm --version) > /dev/null 2>&1
  if ! [[ "$?" == "0" ]]; then
    echo "Please update npm:"
    echo "$ curl -sL https://deb.nodesource.com/setup_16.x -o /tmp/nodesource_setup.sh"
    echo "$ sudo bash /tmp/nodesource_setup.sh"
    echo "$ sudo apt-get install -y nodejs"
    exit 1
  fi

  semver -r ">=1.22" $(yarn --version) > /dev/null 2>&1
  if ! [[ "$?" == "0" ]]; then
    echo "Please update yarn:"
    echo "$ sudo npm install yarn@latest -g --force"
    exit 1
  fi

  if ! [[ -d $my_install_path ]]; then
    echo "$my_install_path is not exist"
    exit 1
  fi

  if ! [[ -f $my_install_path/plugin/coc.vim ]]; then
    echo "$my_install_path/plugin/coc.vim is not exist"
    exit 1
  fi

  yarn --cwd $my_install_path install
  if ! [[ "$?" == "0" ]]; then
    echo "Run yarn install failed"
    exit 1
  fi

  yarn --cwd $my_install_path build
  if ! [[ "$?" == "0" ]]; then
    echo "Run yarn build failed"
    exit 1
  fi

  if ! [[ -f $my_install_path/build/index.js ]]; then
    echo "Please re-run these commands"
    echo "yarn --cwd $my_install_path install"
    echo "yarn --cwd $my_install_path build"
    exit 1
  fi
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
      install_coc "$install_path"
    fi
  else
    echo "Please run $BASH_SOURCE without source"
  fi
}

main "$@"
