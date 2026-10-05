cmake -B build -S $SRC_DIR -DBUILD_SHARED_LIBS=YES $CMAKE_ARGS
cmake --build build --parallel ${CPU_COUNT} --target all tests_jumble
build/test_count_substrings
cmake --install build
