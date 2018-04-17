include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO IntelRealSense/librealsense
    REF v2.10.1
    SHA512 fb00a424a5bd7335cc661261e76cf623e27a89af1033692d4cb6ed523af1295359929c235e82253911e61323cb7b82551a9223862174cb0e2363ac944b2db923
    HEAD_REF development
)

vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES
        ${CMAKE_CURRENT_LIST_DIR}/build_with_static_crt.patch # https://github.com/IntelRealSense/librealsense/pull/1262
        ${CMAKE_CURRENT_LIST_DIR}/fix_rgb_using_avx2.patch # https://github.com/IntelRealSense/librealsense/pull/1245
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" BUILD_LIBRARY_LINKAGE)
string(COMPARE EQUAL "${VCPKG_CRT_LINKAGE}" "static" BUILD_CRT_LINKAGE)

# This option will be deprecated in the later versions.
# Please see Pull Request #1245. https://github.com/IntelRealSense/librealsense/pull/1245
set(RGB_USING_AVX2 OFF)
if("avx2" IN_LIST FEATURES)
    set(RGB_USING_AVX2 ON)
endif()

set(BUILD_EXAMPLES OFF)
set(BUILD_GRAPHICAL_EXAMPLES OFF)
if("tools" IN_LIST FEATURES)
  set(BUILD_EXAMPLES ON)
  set(BUILD_GRAPHICAL_EXAMPLES ON)
  set(BUILD_TOOLS ON)
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DENFORCE_METADATA=ON
        -DBUILD_EXAMPLES=${BUILD_EXAMPLES}
        -DBUILD_GRAPHICAL_EXAMPLES=${BUILD_GRAPHICAL_EXAMPLES}
        -DBUILD_CV_EXAMPLES=OFF
        -DBUILD_PCL_EXAMPLES=OFF
        -DBUILD_PYTHON_BINDINGS=OFF
        -DBUILD_UNIT_TESTS=OFF
        -DBUILD_WITH_OPENMP=OFF
        -DBUILD_SHARED_LIBS=${BUILD_LIBRARY_LINKAGE}
        -DBUILD_WITH_STATIC_CRT=${BUILD_CRT_LINKAGE}
        -DRGB_USING_AVX2=${RGB_USING_AVX2}
    OPTIONS_DEBUG
        "-DCMAKE_PDB_OUTPUT_DIRECTORY=${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg"
        -DCMAKE_DEBUG_POSTFIX="_d"
)

vcpkg_install_cmake()
vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/realsense2)
vcpkg_copy_pdbs()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

if(BUILD_TOOLS)
    file(GLOB EXEFILES_RELEASE ${CURRENT_PACKAGES_DIR}/bin/*.exe)
    file(GLOB EXEFILES_DEBUG ${CURRENT_PACKAGES_DIR}/debug/bin/*.exe)
    file(COPY ${EXEFILES_RELEASE} DESTINATION ${CURRENT_PACKAGES_DIR}/tools/realsense2)
    file(REMOVE ${EXEFILES_RELEASE} ${EXEFILES_DEBUG})
    vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/realsense2)
endif()

file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/realsense2)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/realsense2/COPYING ${CURRENT_PACKAGES_DIR}/share/realsense2/copyright)
