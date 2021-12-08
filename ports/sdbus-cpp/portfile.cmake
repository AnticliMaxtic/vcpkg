vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Kistler-Group/sdbus-cpp
    REF v0.9.0
    HEAD_REF master
    SHA512 8695d3efac5654cb28998cdd69c16f251654b2c95e0dc2a2f5a4b01b24dae7b04e1a1f2e9bc9fb96b99f099dd4a130ca980cb672f74829565fd0d48162a581c5
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
      -D BUILD_TESTS=OFF
      -D BUILD_DOC=OFF
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/sdbus-c++)
vcpkg_fixup_pkgconfig()

# Handle copyright
file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
