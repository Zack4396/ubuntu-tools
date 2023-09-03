#!/bin/bash

usage() {
  cat <<EOF
Usage: $0 --home $HOME --package $HOME/.vim/bundle/global.tar.gz --version 6.6.9

EOF
}

install_gtags() {
  local my_home="$(realpath $1)"
  local my_package="$(realpath $2)"
  local my_package_version="$3"
  local my_bundle="$my_home/.vim/bundle"
  local my_output="$my_home/.vim/bundle/global-$my_package_version"

  # Check
  dpkg -s libncurses-dev > /dev/null 2>&1
  if ! [[ "$?" == "0" ]]; then
    echo "Please install libncurses-dev:"
    echo "$ sudo apt-get install -y libncurses-dev"
    exit 1
  fi

  command -v ctags > /dev/null 2>&1
  if ! [[ "$?" == "0" ]]; then
    echo "Please install ctags:"
    echo "$ sudo apt-get install ctags"
    exit 1
  fi

  if ! [[ -d $my_home ]]; then
    echo "$my_home is not exist"
    exit 1
  else
    echo "Create new folder $my_home/bin"
    mkdir -p $my_home/bin
  fi

  if ! [[ -f $my_package ]]; then
    echo "$my_package is not exist"
    exit 1
  fi

  if ! [[ -d $my_output ]]; then
    echo "Create new folder $my_output "
    mkdir -p $my_output
  else
    if [[ -f $my_output/vim74-gtags-cscope.patch ]]; then
      rm -rf $my_output
    else
      echo "Please remove folder $my_output manually"
      exit 1
    fi
  fi

  # Uncompress
  echo tar -xzf $my_package -C $my_bundle --overwrite
  tar -xzf $my_package -C $my_bundle --overwrite
  if ! [[ "$?" == 0 ]]; then
    echo "Uncompress $my_package Failed"
    exit 1
  fi

  if ! [[ -f $my_output/gtags.vim ]]; then
    echo "Please check if $my_package is a global.zip"
    exit 1
  fi

  pushd $my_output

  # Build
  chmod +x ./configure
  ./configure --quiet
  make -j8 --quiet

  # Install
  mkdir -p ./plugin
  cp ./gtags.vim ./plugin/
  cp ./gtags-cscope.vim ./plugin

  popd

  # Link
  if [[ -f $my_home/bin/global ]]; then
    rm $my_home/bin/global
  fi
  ln -s $my_output/global/global $my_home/bin/global

  if [[ -f $my_home/bin/gtags ]]; then
    rm $my_home/bin/gtags
  fi
  ln -s $my_output/gtags/gtags $my_home/bin/gtags

  if [[ -f $my_home/bin/htags ]]; then
    rm $my_home/bin/htags
  fi
  ln -s $my_output/htags/htags $my_home/bin/htags

  if [[ -f $my_home/bin/gtags-cscope ]]; then
    rm $my_home/bin/gtags-cscope
  fi
  ln -s $my_output/gtags-cscope/gtags-cscope $my_home/bin/gtags-cscope

  #Export Env
  echo "export PATH="\$PATH:$my_home/bin"" >> $my_home/.bashrc
}

main() {
  if [ "$BASH_SOURCE" == "$0" ]; then
    set -e
    if [ "$#" -lt "6" ]; then
      usage "$@"
      exit 1
    else
      local home=""
      local package=""
      local verision=""
      while [[ $# -gt 0 ]]; do
        key="$1"

        case $key in
          --home)
            home="$2"
            shift 2
            ;;
          --package)
            package="$2"
            shift 2
            ;;
          --version)
            version="$2"
            shift 2
            ;;
          *)
            echo "Unknown: $1"
            exit 1
            ;;
        esac
      done
      install_gtags "$home" "$package" "$version"
    fi
  else
    echo "Please run $BASH_SOURCE without source"
  fi
}

main "$@"
