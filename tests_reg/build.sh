rm -rf build_spe
rm -rf build_app

WEST_TOPDIR=`west topdir`
TFM_SOURCE_PATH=$WEST_TOPDIR/trusted-firmware-m
TFM_TESTS_PATH=$WEST_TOPDIR/tf-m-tests
CWD=`pwd`

cmake -GNinja -S $TFM_TESTS_PATH/tests_reg/spe -B build_spe \
        -DTFM_PLATFORM=nordic_nrf/nrf9160dk_nrf9160 \
        -DTFM_TOOLCHAIN_FILE=$TFM_SOURCE_PATH/toolchain_GNUARM.cmake \
        -DCONFIG_TFM_SOURCE_PATH=$TFM_SOURCE_PATH \
        -DTEST_S=ON -DTEST_NS=ON

cmake --build build_spe -- install

cmake -GNinja -S $TFM_TESTS_PATH/tests_reg -B build_app \
        -DCONFIG_SPE_PATH=$CWD/build_spe/api_ns \
        -DCMAKE_BUILD_TYPE=RelWithDebInfo \
        -DTFM_TOOLCHAIN_FILE=cmake/toolchain_ns_GNUARM.cmake

cmake --build build_app
