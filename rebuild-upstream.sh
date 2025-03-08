#!/bin/bash

# Manually fetch the upstream master and switch to it.
# Run this to rebuild the stage3 compiler. The result is usually usable for
# several weeks.

rm -r build
mkdir build

# With ninja
pushd build
cmake .. \
  -G Ninja \
  -DCMAKE_PREFIX_PATH=$HOME/local/llvm19-assert \
  -DCMAKE_BUILD_TYPE=Release
time ninja install
popd

# With make
#pushd build
#cmake .. \
#  -DCMAKE_PREFIX_PATH=$HOME/local/llvm19-assert \
#  -DCMAKE_BUILD_TYPE=Release
#time make install -j6
#popd
