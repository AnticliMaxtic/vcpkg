vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Kistler-Group/sdbus-cpp
    REF v1.0.0
    HEAD_REF master
    SHA512 dc6b6c4945f5203ad5e4d86ae78088ce367a5ee28f3bb1c17c116c0755d9b221685a92b32dd9e354351067b012768e8d42ebe5dac93199d1384b9b4dadec09ef
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
      -D BUILD_DOC=OFF
      -D BUILD_EXAMPLES=OFF
      -D BUILD_TESTS=OFF
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/sdbus-c++)
vcpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
# Handle copyright
file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
