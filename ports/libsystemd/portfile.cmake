set(VERSION 249.7)
set(SHA512
    f5dd0f02fcae65a176a16af9a8e1747c26e9440c6c224003ba458d3298b777a75ffb189aee9051fb0c4840b2a48278be4a51d959381af0b1d627570f478c58f2
)
# cmake-format: off
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/systemd/systemd-stable/archive/v${VERSION}.tar.gz"
    FILENAME "v${VERSION}-src.tar.bz2"
    SHA512 4daf8570621fdcda5c94d982908c64eddfeef989005f4fd79a10f199dbc6f366354177bb59dff34bcb14764fb4423a870ffabac1163849ec53592e29760105fc
)
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    PATCHES "0001-missing_syscalls.py-replace-unicode-with-ascii.patch" "0001-convert-libsystemd.pc.in-to-cmake-replace-format.patch"
)
# cmake-format: on

list(APPEND _opts "-Drootprefix=${CURRENT_PACKAGES_DIR}")
# list(APPEND _opts "-Dtests=false" "-Dsysconfdir=${CURRENT_PACKAGES_DIR}"
# "-Dinstall-sysconfdir=false")
list(APPEND _opts "-Dtests=false")

# options unrelated to libsystemd
list(
  APPEND
  UNRELATED
  "-Dfdisk=false"
  "-Dseccomp=false"
  "-Dpwquality=false"
  "-Dapparmor=false"
  "-Dpolkit=false"
  "-Daudit=false"
  "-Dkmod=false"
  "-Dmicrohttpd=false"
  "-Dlibcryptsetup=false"
  "-Dlibcurl=false"
  "-Dlibidn=false"
  "-Dlibidn2=false"
  "-Dqrencode=false"
  "-Dopenssl=false"
  "-Dlibfido2=false"
  "-Dzlib=false"
  "-Dxkbcommon=false"
  "-Dpcre2=false"
  "-Dglib=false"
  "-Ddbus=false"
  "-Dblkid=false"
  "-Dgcrypt=false"
  "-Dp11kit=false"
  "-Dima=false"
  "-Dsmack=false"
  "-Dbzip2=false"
  "-Dgnutls=false"
  "-Didn=false"
  "-Dinitrd=false"
  "-Dbinfmt=false"
  "-Dvconsole=false"
  "-Dquotacheck=false"
  "-Dtmpfiles=false"
  "-Denvironment-d=false"
  "-Dsysusers=false"
  "-Dfirstboot=false"
  "-Drandomseed=false"
  "-Dbacklight=false"
  "-Drfkill=false"
  "-Dxdg-autostart=false"
  "-Dlogind=false"
  "-Dhibernate=false"
  "-Dmachined=false"
  "-Dportabled=false"
  "-Duserdb=false"
  "-Dhostnamed=false"
  "-Dtimedated=false"
  "-Dtimesyncd=false"
  "-Dlocaled=false"
  "-Dnetworkd=false"
  "-Dresolve=false"
  "-Dcoredump=false"
  "-Dpstore=false"
  "-Defi=false"
  "-Dnss-myhostname=false"
  "-Dnss-mymachines=false"
  "-Dnss-resolve=false"
  "-Dnss-systemd=false"
  "-Dhwdb=false"
  "-Dtpm=false"
  "-Dman=false"
  "-Dhtml=false"
  "-Dutmp=false"
  "-Dldconfig=false"
  "-Dadm-group=false"
  "-Dwheel-group=false"
  "-Dgshadow=false"
  "-Dinstall-tests=false"
  "-Dlink-udev-shared=false"
  "-Dlink-systemctl-shared=false"
  "-Danalyze=false"
  "-Dpam=false"
  "-Dlink-networkd-shared=false"
  "-Dlink-timesyncd-shared=false"
  "-Dkernel-install=false"
  "-Dlibiptc=false"
  "-Delfutils=false"
  "-Drepart=false"
  "-Dhomed=false"
  "-Dimportd=false"
  "-Dacl=false"
  "-Ddns-over-tls=false"
  "-Dgnu-efi=false"
  "-Dvalgrind=false"
  "-Dlog-trace=false")

list(APPEND _opts ${UNRELATED})

find_program(
  GPERF
  NAMES gperf
  HINTS ${CURRENT_HOST_INSTALLED_DIR}/tools)
get_filename_component(gperf_dir "${GPERF}" DIRECTORY)
vcpkg_add_to_path("${gperf_dir}")

vcpkg_configure_meson(
  SOURCE_PATH
  ${SOURCE_PATH}
  OPTIONS
  ${_opts}
  OPTIONS_DEBUG
  "-Dmode=developer"
  OPTIONS_RELEASE
  "-Dmode=release")

if(VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
  vcpkg_build_ninja(TARGETS "version.h" "libsystemd.so.${VERSION}")
else()
  vcpkg_build_ninja(TARGETS "version.h" "libsystemd.a")
endif()
# vcpkg_install_meson() vcpkg_fixup_pkgconfig() vcpkg_copy_pdbs()

# Install
if(NOT VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "debug")
  set(_buildType "dbg")
elseif(NOT VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "release")
  set(_buildType "rel")
endif()
if(VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
  set(_libExtension "so.*")
else()
  set(_libExtension "a")
endif()

##  Include files
file(
  INSTALL ${SOURCE_PATH}/src/systemd
  DESTINATION ${CURRENT_PACKAGES_DIR}/include
  PATTERN "*.h")
file(INSTALL ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-${_buildType}/version.h
     DESTINATION ${CURRENT_PACKAGES_DIR}/include)

## librarys
file(
  INSTALL ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-${_buildType}/libsystemd.${_libExtension}
  DESTINATION ${CURRENT_PACKAGES_DIR}/lib
  FOLLOW_SYMLINK_CHAIN
  )

## helper files
set(PREFIX ${CURRENT_INSTALLED_DIR})
set(ROOTLIBDIR ${CURRENT_INSTALLED_DIR}/lib)
set(INCLUDE_DIR ${CURRENT_INSTALLED_DIR}/include)
set(PROJECT_URL "https://www.freedesktop.org/wiki/Software/systemd")
set(PROJECT_VERSION ${VERSION})
configure_file(${SOURCE_PATH}/src/libsystemd/libsystemd.pc.in
               ${CURRENT_PACKAGES_DIR}/lib/pkgconfig/libsystemd.pc @ONLY)
unset(PROJECT_VERSION)
unset(PROJECT_URL)
unset(INCLUDE_DIR)
unset(ROOTLIBDIR)
unset(PREFIX)

# Handle copyright
file(
  INSTALL ${SOURCE_PATH}/LICENSE.GPL2
  DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT}
  RENAME copyright)
file(COPY ${SOURCE_PATH}/LICENSE.GPL2 ${SOURCE_PATH}/LICENSE.LGPL2.1
     DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT})

# Allow empty include directory
set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)
