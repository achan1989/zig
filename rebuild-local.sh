#!/bin/sh

# Create a local branch and switch to it. Make whatever changes.
# Run this to rebuild the stage4 compiler which includes the local changes.

time build/stage3/bin/zig build -p build/stage4 -Denable-llvm -Dno-lib -freference-trace
