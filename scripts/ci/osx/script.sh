#!/bin/bash
set -ev

SCRIPTDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $SCRIPTDIR/../funcs.sh

mkdir -p build
pushd build


unset `env | \
grep -vi '^EDITOR=\|^HOME=\|^LANG=\|MXE\|^PATH=' | \
grep -vi 'PKG_CONFIG\|PROXY\|^PS1=\|^TERM=\|^TRAVIS_OS_NAME=\|^UPLOAD_KEY=' | \
   cut -d '=' -f1 | tr '\n' ' '`

QTDIR="/usr/local/opt/qt5"
PATH="$QTDIR/bin:$PATH"
LDFLAGS=-L$QTDIR/lib
CPPFLAGS=-I$QTDIR/include

make_version ..
qmake ../calaos_installer.pro
make
mkdir machine_creator
cd machine_creator
qmake ../../machine_creator/machine_creator.pro
make

popd
