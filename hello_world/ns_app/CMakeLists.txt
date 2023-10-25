#-------------------------------------------------------------------------------
# Copyright (c) 2023, Nordic Semiconductor ASA.
#
# SPDX-License-Identifier: BSD-3-Clause
#
#-------------------------------------------------------------------------------

cmake_minimum_required(VERSION 3.15)

set(TFM_TOOLCHAIN_FILE    ${CONFIG_SPE_PATH}/cmake/toolchain_ns_GNUARM.cmake)

list(APPEND CMAKE_MODULE_PATH ${CONFIG_SPE_PATH}/cmake)

# A platform sprecific MCPU and architecture flags for NS side
include(${CONFIG_SPE_PATH}/platform/cpuarch.cmake)

include(${TFM_TOOLCHAIN_FILE})
include(spe_config)
tfm_toolchain_reload_compiler()

project("TF-M NS Application" LANGUAGES C ASM)

add_executable(tfm_ns
        main.c
        ${CONFIG_SPE_PATH}/interface/src/os_wrapper/tfm_ns_interface_bare_metal.c
)

add_subdirectory(${CONFIG_SPE_PATH} tfm-api-ns)

target_link_libraries(tfm_ns tfm_api_ns)

set_target_properties(tfm_ns PROPERTIES
    SUFFIX ".axf"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
)


target_add_scatter_file(tfm_ns ${CONFIG_SPE_PATH}/platform/linker_scripts)

target_link_options(tfm_ns
    PRIVATE
        -Wl,-Map=${CMAKE_BINARY_DIR}/bin/tfm_ns.map
)

add_convert_to_bin_target(tfm_ns)

