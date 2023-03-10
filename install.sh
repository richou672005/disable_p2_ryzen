#!/bin/sh

set -e

PREFIX="/usr/local"

while [ $# -gt 0 ] ; do
  case "$1" in
    --prefix=*)
      PREFIX="${1#*=}"
      ;;
    --help)
      echo "Installs the disable-p2.service systemd unit."
      echo "Usage: `basename $0` [options]"
      echo "Options:"
      echo "  --prefix=PREFIX  Installation prefix (default: /usr/local)"
      exit 0
      ;;
    *)
      echo "Invalid argument: $1"
      exit 1
      ;;
  esac
  shift
done

BIN_DIR=$PREFIX/bin
LIB_DIR=$PREFIX/lib/systemd/system

mkdir -p $BIN_DIR
mkdir -p $LIB_DIR

echo "Installing $LIB_DIR/disable-p2.service"
sed "s@{{PREFIX}}@$PREFIX@" disable-p2.service.template > $LIB_DIR/disable-p2.service
echo "Installing $BIN_DIR/zenstates.py"
install lib/ZenStates-Linux/zenstates.py $BIN_DIR/zenstates.py

while true ; do
  read -p "Would you like to enable and start the service now [y/N]? " YN
  case $YN in
    [Yy]*)
      systemctl enable disable-p2.service
      systemctl start disable-p2.service
      echo "Enabled disable-p2 service."
      exit 0
      ;;
    *)
      echo "To enable and start the service:"
      echo "    systemctl enable disable-p2.service"
      echo "    systemctl start disable-p2.service"
      exit 0
      ;;
  esac
done
