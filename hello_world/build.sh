#! /bin/bash

rm -rf build_spe
rm -rf build_app

WEST_TOPDIR=`west topdir`
TFM_SOURCE_PATH=$WEST_TOPDIR/trusted-firmware-m
CWD=`pwd`

boards=("nrf9160dk_nrf9160" "nrf5340dk_nrf5340_cpuapp")

if echo "${boards[@]}" | grep -qw "$1"; then
  board=$1
else
  select board in "${boards[@]}"; do break ; done
fi

echo "Building for board $board"

cmake -GNinja -S $TFM_SOURCE_PATH -B build_spe \
        -DTFM_PLATFORM=nordic_nrf/$board \
        -DTFM_TOOLCHAIN_FILE=$TFM_SOURCE_PATH/toolchain_GNUARM.cmake \
        -DTFM_SPM_LOG_LEVEL="TFM_SPM_LOG_LEVEL_DEBUG" \
        -DTFM_PARTITION_LOG_LEVEL="TFM_PARTITION_LOG_LEVEL_DEBUG" \
        -DTFM_EXCEPTION_INFO_DUMP=ON \
        -DTFM_PARTITION_PROTECTED_STORAGE=ON \
        -DTFM_PARTITION_INTERNAL_TRUSTED_STORAGE=ON \
        -DTFM_PARTITION_CRYPTO=ON \
        -DTFM_PARTITION_PLATFORM=ON

cmake --build build_spe -- install

cmake -GNinja -S ns_app -B build_app \
        -DCONFIG_SPE_PATH=$CWD/build_spe/api_ns \
        -DCMAKE_BUILD_TYPE=RelWithDebInfo \
        -DTFM_TOOLCHAIN_FILE=cmake/toolchain_ns_GNUARM.cmake

cmake --build build_app
