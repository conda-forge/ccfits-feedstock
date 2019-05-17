#!/bin/bash

declare -a CMAKE_PLATFORM_FLAGS
if [[ -n "${OSX_ARCH}" ]]; then
    CMAKE_PLATFORM_FLAGS+=(-DCMAKE_OSX_SYSROOT="${CONDA_BUILD_SYSROOT}")
else
    CMAKE_PLATFORM_FLAGS+=(-DCMAKE_TOOLCHAIN_FILE="${RECIPE_DIR}/cross-linux.cmake")
fi

mkdir build
cd build

cmake \
    -DCMAKE_PREFIX_PATH=${PREFIX} \
    -DCMAKE_INSTALL_PREFIX:PATH=${PREFIX} \
    -DBUILD_SHARED_LIBS=on \
    ${CMAKE_PLATFORM_FLAGS[@]} \
    ..

make CCfits

# really cmake?
# cookbook looks for installed headers which are not there
# because you cannot install without building the cookbook which
# won't build due to the lack of installed headers
# hence I am hacking them in by hand
# it appears cmake uses a glob as well for the headers so nothing
# extra is leaking into the build
mkdir -p ${PREFIX}/include/CCfits
cp ../*.h ${PREFIX}/include/CCfits/.
make cookbook

make install

# Remove the cookbook binary
rm -rf $PREFIX/bin/cookbook
