#!/bin/bash

cd CCfits
autoreconf -if
./configure --with-cfitsio=${PREFIX} --prefix=${PREFIX}

[[ "$target_platform" == "win-64" ]] && patch_libtool

make
make install
