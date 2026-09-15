# Using Jumble from conda-forge

Jumble provides builds made with gfortran 14 and gfortran 15. Each build includes
both the shared library and `jumble.mod`. The module file is read when compiling
code containing `use jumble`; a compiler is not required just to run an already
compiled program.

## Select a build and compiler

For Linux x86-64, create and activate a development environment:

```sh
conda create -n jumble-dev -c conda-forge "jumble=0.2=gfortran14_*" "gfortran_linux-64=14"
conda activate jumble-dev
"$FC" --version
```

For the gfortran 15 build, use `"jumble=0.2=gfortran15_*"` and
`"gfortran_linux-64=15"`. On macOS Intel, replace `gfortran_linux-64` with
`gfortran_osx-64`. These packages target Linux x86-64 and macOS Intel; Apple Silicon
native builds are not currently included in the feedstock.

The build string explicitly selects the module format. When using a separately
installed system compiler, select a compatible Jumble build yourself: conda cannot
detect or constrain that compiler. Installing Jumble alone does not install a
compiler. Its `run_constraints` only restrict compiler packages installed in the
same environment, not those in a separate downstream build environment.

## Compile a program

Save this as `consumer.f90`:

```fortran
program consumer
  use jumble, only: count_substrings
  implicit none
  if (count_substrings("ababababab", "abab") /= 2) error stop 1
end program consumer
```

Compile and run it using the activated environment's compiler:

```sh
"$FC" -I"$CONDA_PREFIX/include" consumer.f90 -L"$CONDA_PREFIX/lib" \
  -Wl,-rpath,"$CONDA_PREFIX/lib" -ljumble -o consumer
./consumer
```

Use `$FC` to avoid accidentally invoking a different compiler installed on the
system. With CMake, select `$FC` as `CMAKE_Fortran_COMPILER` when first configuring
a new build directory.

## Module compatibility tests

The recipe compiles and runs a consumer against the installed package in separate
test environments:

| Jumble build compiler | Consumer compilers |
| --- | --- |
| gfortran 14 | gfortran 13, 14, and 15 |
| gfortran 15 | gfortran 15 |

The [GCC 15 release notes](https://gcc.gnu.org/gcc-15/changes.html#fortran)
state that gfortran 15 can read modules produced by gfortran 8–14. The reverse is
not supported: modules produced by gfortran 15 cannot be read by gfortran 13/14.
The tests above check both module reading and a library call; they do not establish
compatibility with every compiler, compiler option, or runtime combination.
