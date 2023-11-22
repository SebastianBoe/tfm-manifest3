#! /bin/bash

rm -rf build_spe
rm -rf build_app

WEST_TOPDIR=`west topdir`
TFM_SOURCE_PATH=$WEST_TOPDIR/trusted-firmware-m
TFM_TESTS_PATH=$WEST_TOPDIR/tf-m-tests
CWD=`pwd`

boards=("nrf9160dk_nrf9160" "nrf5340dk_nrf5340_cpuapp")

if echo "${boards[@]}" | grep -qw "$1"; then
  board=$1
else
  select board in "${boards[@]}"; do break ; done
fi

echo "Building for board $board"

cmake -GNinja -S $TFM_TESTS_PATH/tests_reg/spe -B build_spe \
        -DTFM_PLATFORM=nordic_nrf/$board \
        -DTFM_TOOLCHAIN_FILE=$TFM_SOURCE_PATH/toolchain_GNUARM.cmake \
        -DCONFIG_TFM_SOURCE_PATH=$TFM_SOURCE_PATH \
        -DTEST_S=ON -DTEST_NS=ON

cmake --build build_spe -- install

cmake -GNinja -S $TFM_TESTS_PATH/tests_reg -B build_app \
        -DCONFIG_SPE_PATH=$CWD/build_spe/api_ns \
        -DCMAKE_BUILD_TYPE=RelWithDebInfo \
        -DTFM_TOOLCHAIN_FILE=cmake/toolchain_ns_GNUARM.cmake

cmake --build build_app
