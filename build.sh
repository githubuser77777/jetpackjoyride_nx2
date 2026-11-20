#!/usr/bin/env bash
set -e
export DEVKITPRO=/opt/devkitpro
export DEVKITA64=/opt/devkitpro/devkitA64
export DEVKITARM=/opt/devkitpro/devkitARM
export DEVKITPPC=/opt/devkitpro/devkitPPC
export PATH=$DEVKITA64/bin:$DEVKITPRO/tools/bin:$DEVKITPRO/portlibs/switch/bin:$PATH
for arg in "$@"; do
  if [ "$arg" = "SWITCH2=1" ]; then
    export PKG_CONFIG_PATH="$DEVKITPRO/portlibs/switch2/lib/pkgconfig:$DEVKITPRO/portlibs/switch/lib/pkgconfig${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"
  fi
done
cd "$(dirname "$0")" || exit 1
if [ "$1" = "clean" ]; then make clean; shift; fi
make "$@"
