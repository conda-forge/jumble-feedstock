#!/usr/bin/env bash
set -euxo pipefail

cat > consumer.f90 <<'EOF'
program consumer
  use jumble, only: count_substrings
  implicit none
  if (count_substrings("ababababab", "abab") /= 2) error stop 1
end program consumer
EOF

"${FC}" --version
"${FC}" -I"${PREFIX}/include" consumer.f90 -L"${PREFIX}/lib" \
  -Wl,-rpath,"${PREFIX}/lib" -ljumble -o consumer
./consumer
