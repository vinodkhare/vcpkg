include(vcpkg_common_functions)

# The following is needed because there is no separate include folder
set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO vinodkhare/apriltag
    REF b0ceeb92a56da93f5316ab28d282207188d1add0
    SHA512 0b5bbad9b0c5362deede0e7655346d05f31b3185f132ef363e3e3f5653fa4b83495a88b740909336dcb0a3b168ed6514d76518edeeefef788bb93a58c33151a6
    HEAD_REF master
)

set(CMAKE_TOOLCHAIN_FILE ${CMAKE_CURRENT_BINARY_DIR}/scripts/buildsystems/vcpkg.cmake)

vcpkg_configure_cmake(
    DISABLE_PARALLEL_CONFIGURE
    SOURCE_PATH ${SOURCE_PATH}
    GENERATOR "Visual Studio 16 2019"
    OPTIONS -A x64 -DCMAKE_TOOLCHAIN_FILE=${CMAKE_CURRENT_BINARY_DIR}/scripts/buildsystems/vcpkg.cmake)

vcpkg_install_cmake()

## The following ensure that post build checks within vcpkg pass.

# Copy license file from apriltag to vcpkg
file(INSTALL ${SOURCE_PATH}/LICENSE.md DESTINATION ${CURRENT_PACKAGES_DIR}/share/apriltag RENAME copyright)

# Remove include files from the debug/include directory. Otherwise vcpkg throws a warning.
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

# Similar for debug/share but we copy the cmake files there into install/share/apriltag
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/installed/${TARGET_TRIPLET}/share/apriltag)
file(GLOB APRILTAG_CMAKE_FILES ${CURRENT_PACKAGES_DIR}/debug/share/apriltag/cmake/*.cmake)
file(COPY ${APRILTAG_CMAKE_FILES} DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/installed/${TARGET_TRIPLET}/share/apriltag)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

# Copy release EXEs to ${CURRENT_PACKAGES_DIR}/tools
file(GLOB APRILTAG_EXE_FILES ${CURRENT_PACKAGES_DIR}/bin/*.exe)
file(COPY ${APRILTAG_EXE_FILES} DESTINATION ${CURRENT_PACKAGES_DIR}/tools)

# Delete debug and release EXEs
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/bin/)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin/)