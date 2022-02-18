# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/any
    REF boost-1.78.0
    SHA512 fd9670fc4d7086fc28131c8d02b5dcd0d4bbcfdf54720df1859c50079d77d19d6c08a70421b1c0ec7c13f3b31b8606eaa8f8db847fd359cf03e24f913b0e660c
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
