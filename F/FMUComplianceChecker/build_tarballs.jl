# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder, Pkg

name = "FMUComplianceChecker"
version = v"2.0.4"

# Collection of sources required to complete build
sources = [
    ArchiveSource("https://github.com/modelica-tools/FMUComplianceChecker/archive/f0fd0b2ca78c415a725b028deec46c1962799f1d.zip", "db4607e7b6230d9b7f2e394e6ec132e90cee19ae6625997c09d946ab61dda156")
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir

apk add subversion
mkdir ${bindir}/

cd FMUComplianceChecker-*/   

mkdir build; cd build
cmake -DCMAKE_INSTALL_PREFIX=${prefix} -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TARGET_TOOLCHAIN} -DCMAKE_BUILD_TYPE=Release ..
make install test

install_license "../LICENSE"
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Platform("x86_64", "windows"; ),
    Platform("x86_64", "linux"; libc = "glibc"),
]


# The products that we will ensure are always built
products = [
    ExecutableProduct("fmuCheck", :libFMUCheck)
]

# Dependencies that must be installed before this package can be built
dependencies = Dependency[
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies; julia_compat="1.6")
