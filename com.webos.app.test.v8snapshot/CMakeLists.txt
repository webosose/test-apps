# @@@LICENSE
#
# (c) Copyright 2022  LG Electronics, Inc.
#
# Confidential computer software. Valid license from HP required for
# possession, use or copying. Consistent with FAR 12.211 and 12.212,
# Commercial Computer Software, Computer Software Documentation, and
# Technical Data for Commercial Items are licensed to the U.S. Government
# under vendor's standard commercial license.
#
# LICENSE@@@
cmake_minimum_required(VERSION 2.8.7)
project(com.webos.app.test.v8snapshot NONE)
include(webOS/webOS)
webos_modules_init(1 0 0 QUALIFIER RC4)

add_custom_command(OUTPUT ${PROJECT_BINARY_DIR}/snapshot_blob.bin
  COMMAND  ${V8_MKSNAPSHOT} --startup-blob snapshot_blob.bin ${CMAKE_SOURCE_DIR}/snapshot_test.js
  DEPENDS snapshot_test.js)

add_custom_target(mksnapshot ALL
  COMMAND echo "Update snapshot_blob"
  DEPENDS ${PROJECT_BINARY_DIR}/snapshot_blob.bin)

set(INSTALL_DIR ${WEBOS_INSTALL_WEBOS_APPLICATIONSDIR}/${CMAKE_PROJECT_NAME})
#install necessary files to destination directory
install(DIRECTORY . DESTINATION ${INSTALL_DIR}
        PATTERN "*~" EXCLUDE
        PATTERN "CMake*" EXCLUDE
        PATTERN "mock" EXCLUDE
        PATTERN "BUILD*" EXCLUDE
        PATTERN "patches" EXCLUDE
        PATTERN ".git*" EXCLUDE
        PATTERN "*.js" EXCLUDE
        PATTERN ".project" EXCLUDE)

install(FILES ${PROJECT_BINARY_DIR}/snapshot_blob.bin DESTINATION ${INSTALL_DIR})
