#!/usr/bin/env bash
set -euxo pipefail

"${FC}" --version
"${FC}" -I"${PREFIX}/include" NR_util/test_nr_util.f90 -L"${PREFIX}/lib" \
  -Wl,-rpath,"${PREFIX}/lib" -ljumble -o test_nr_util
./test_nr_util
