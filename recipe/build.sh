#!/bin/bash

cd CCfits
autoreconf -if
./configure --with-cfitsio=${PREFIX} --prefix=${PREFIX}
make
make install
