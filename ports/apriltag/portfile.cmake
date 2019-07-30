include(vcpkg_common_functions)

# The following is needed because there is no separate include folder
set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO vinodkhare/apriltag
    REF 292e548f89fa9739b62f5e7a1e113db8f6cbd8ac
    SHA512 750430f95da9aafb60cd6a0d8c3156b279d92c51b70398c57e432e119c44b13121501e0dc7dc9f4c82be640bf6eda3dc805b046c3aa4a93d91661ae415438b97
    HEAD_REF master)

vcpkg_configure_cmake(SOURCE_PATH ${SOURCE_PATH})

vcpkg_install_cmake()

## The following ensure that post build checks within vcpkg pass.

# Copy license file from apriltag to vcpkg
file(INSTALL ${SOURCE_PATH}/LICENSE.md DESTINATION ${CURRENT_PACKAGES_DIR}/share/apriltag RENAME copyright)

# Install Debug DLLs
file(GLOB APRILTAG_DLL_FILES ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/Debug/*.dll
                             ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/Debug/*.pdb
                             ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/Debug/*.ilk)

file(INSTALL ${APRILTAG_DLL_FILES} DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin)

# Install Release DLLs
file(GLOB APRILTAG_DLL_FILES ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/Release/*.dll
                             ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/Release/*.pdb
                             ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/Release/*.ilk)

file(INSTALL ${APRILTAG_DLL_FILES} DESTINATION ${CURRENT_PACKAGES_DIR}/bin)

# Install Debug LIBs
file(GLOB APRILTAG_DLL_FILES ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/lib/Debug/*.exp
                             ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/lib/Debug/*.lib)

file(INSTALL ${APRILTAG_DLL_FILES} DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)

# Install Release LIBs
file(GLOB APRILTAG_DLL_FILES ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/lib/Release/*.exp
                             ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/lib/Release/*.lib)

file(INSTALL ${APRILTAG_DLL_FILES} DESTINATION ${CURRENT_PACKAGES_DIR}/lib)

file(GLOB EXE_FILES ${CURRENT_PACKAGES_DIR}/debug/bin/*.exe)
file(COPY ${EXE_FILES} DESTINATION ${CURRENT_PACKAGES_DIR}/debug/tools)
file(REMOVE ${EXE_FILES})

file(GLOB EXE_FILES ${CURRENT_PACKAGES_DIR}/bin/*.exe)
file(COPY ${EXE_FILES} DESTINATION ${CURRENT_PACKAGES_DIR}/tools)
file(REMOVE ${EXE_FILES})

vcpkg_fixup_cmake_targets(CONFIG_PATH share/apriltag/cmake)

# Remove include files from the debug/include directory. Otherwise vcpkg throws a warning.
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

# file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/bin)
# file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin)
# file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

# # Similar for debug/share but we copy the cmake files there into install/share/apriltag
# file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/installed/${TARGET_TRIPLET}/share/apriltag)
# file(GLOB APRILTAG_CMAKE_FILES ${CURRENT_PACKAGES_DIR}/debug/share/apriltag/cmake/*.cmake)
# file(COPY ${APRILTAG_CMAKE_FILES} DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/installed/${TARGET_TRIPLET}/share/apriltag)
# file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

# Copy release EXEs to ${CURRENT_PACKAGES_DIR}/tools
# file(GLOB APRILTAG_EXE_FILES ${CURRENT_PACKAGES_DIR}/bin/*.exe)
# file(COPY ${APRILTAG_EXE_FILES} DESTINATION ${CURRENT_PACKAGES_DIR}/tools)

# Delete debug and release EXEs
# file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/bin/)
# file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin/)