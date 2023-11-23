#! /bin/bash

rm -rf build_spe
rm -rf build_app

WEST_TOPDIR=`west topdir`
TFM_SOURCE_PATH=$WEST_TOPDIR/trusted-firmware-m
TFM_TESTS_PATH=$WEST_TOPDIR/tf-m-tests
CWD=`pwd`

boards=("nrf9160dk_nrf9160" "nrf5340dk_nrf5340_cpuapp" "nrf9161dk_nrf9161")

if echo "${boards[@]}" | grep -qw "$1"; then
  board=$1
else
  select board in "${boards[@]}"; do break ; done
fi

echo "Building for board $board"

api_tests=("CRYPTO" \
           "INTERNAL_TRUSTED_STORAGE" \
           "PROTECTED_STORAGE" \
           "STORAGE" \
           "INITIAL_ATTESTATION" \
           "IPC" \
           )

if echo "${api_tests[@]}" | grep -qw "$2"; then
  api_test=$2
else
  select api_test in "${api_tests[@]}"; do break ; done
fi

cmake -GNinja -S $TFM_TESTS_PATH/tests_psa_arch/spe -B build_spe \
        -DTFM_PLATFORM=nordic_nrf/$board \
        -DTFM_TOOLCHAIN_FILE=$TFM_SOURCE_PATH/toolchain_GNUARM.cmake \
        -DMBEDCRYPTO_PATH=$WEST_TOPDIR/mbedtls \
        -DMBEDCRYPTO_FORCE_PATCH=ON \
        -DHAL_NORDIC_PATH=$WEST_TOPDIR/hal_nordic \
        -DMCUBOOT_PATH=$WEST_TOPDIR/mcuboot \
        -DQCBOR_PATH=$WEST_TOPDIR/qcbor \
        -DCONFIG_TFM_SOURCE_PATH=$TFM_SOURCE_PATH \
        -DTEST_PSA_API=$api_test

cmake --build build_spe -- install

cmake -GNinja -S $TFM_TESTS_PATH/tests_psa_arch -B build_app \
        -DCONFIG_SPE_PATH=$CWD/build_spe/api_ns \
        -DTFM_TOOLCHAIN_FILE=cmake/toolchain_ns_GNUARM.cmake \
        -DCMAKE_BUILD_TYPE=RelWithDebInfo
        # -DQCBOR_PATH

cmake --build build_app
