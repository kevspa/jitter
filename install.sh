#!/bin/bash

usage() {
  echo "
  Usage: $0 [-f --force] [--uninstall]
  
  Options:
    -f --force:  Force installation.
    --uninstall: Uninstall Jitter
  "
  exit 1
}

while [ "$1" != "" ]; do
    case $1 in
    -f | --force)
        FORCE=true
        ;;
    --uninstall)
        shift
        UNINSTALL=true
        ;;
    -h | --help)
        usage
        ;;
    *)
        usage
        ;;
    esac
    shift
done

if [[ $UNINSTALL ]]; then
  if [[ -d "$HOME/.jitter" ]]; then
    echo "You will delete all installed packages and Jitter itself."
    read -n 1 -p "Do you want to continue? (y/N) "
    echo
    if [[ $REPLY =~ [Yy] ]]; then
      rm -rf "$HOME/.jitter"
      echo "Successfully uninstalled"
      exit 0
    fi
  else
    echo "Jitter is not installed"
    exit 1
  fi
else
  if [[ ! -d "$HOME/.jitter" || $FORCE ]]; then
    echo "Creating $HOME/.jitter directory"
    
    if [[ ! -d "$HOME/.jitter" ]]; then mkdir $HOME/.jitter; fi
    if [[ ! -d "$HOME/.jitter/bin" ]]; then mkdir $HOME/.jitter/bin; fi
    if [[ ! -d "$HOME/.jitter/nerve" ]]; then mkdir $HOME/.jitter/nerve; fi
    if [[ ! -d "$HOME/.jitter/config" ]]; then mkdir $HOME/.jitter/config; fi

    echo "Downloading latest Jitter release to $HOME/.jitter/bin"
    wget -o $HOME/.jitter/bin/jtr.tar.gz https://github.com/sharpcdf/jitter/releases/latest/download/jtr.tar.gz
    tar -xfv $HOME/.jitter/bin/jtr.tar.gz
    chmod +x $HOME/.jitter/bin/jtr
    rm -rf $HOME/.jitter/bin/jtr.tar.gz
    echo "Consider adding $HOME/.jitter/bin to your PATH running the following command: "
    echo "echo 'export PATH=\$PATH:$HOME/.jitter/bin' >> $HOME/.bashrc"
    exit 0

  else
    echo "Jitter is already installed, force an installation using the --force flag or uninstall it using the --uninstall flag."
    exit 1
  fi
fi
