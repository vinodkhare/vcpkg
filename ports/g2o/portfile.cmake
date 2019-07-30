include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO RainerKuemmerle/g2o
    REF 9b41a4ea5ade8e1250b9c1b279f3a9c098811b5a
    SHA512 011de54eafac646e114da887ca9ba9588f1cf15afa977f724af1417aca7b24dd4f68ab37e5ff2439b1d1c9376433bcbdf0c10ff9eba89005e92391fedb8ea612
    HEAD_REF master
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" BUILD_LGPL_SHARED_LIBS)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DBUILD_LGPL_SHARED_LIBS=${BUILD_LGPL_SHARED_LIBS}
        -DG2O_BUILD_EXAMPLES=OFF
        -DG2O_BUILD_APPS=OFF
)

vcpkg_install_cmake()

vcpkg_copy_pdbs()

if(VCPKG_USE_HEAD_VERSION)
	vcpkg_fixup_cmake_targets(CONFIG_PATH "lib/cmake/g2o")
endif()

if(VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
    file(GLOB_RECURSE HEADERS "${CURRENT_PACKAGES_DIR}/include/*")
    foreach(HEADER ${HEADERS})
        file(READ ${HEADER} HEADER_CONTENTS)
        string(REPLACE "#ifdef G2O_SHARED_LIBS" "#if 1" HEADER_CONTENTS "${HEADER_CONTENTS}")
        file(WRITE ${HEADER} "${HEADER_CONTENTS}")
    endforeach()
endif()

file(GLOB EXE ${CURRENT_PACKAGES_DIR}/bin/*.exe)
file(GLOB DEBUG_EXE ${CURRENT_PACKAGES_DIR}/debug/bin/*.exe)
if(EXE OR DEBUG_EXE)
    file(REMOVE ${EXE} ${DEBUG_EXE})
endif()
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

# Put the license file where vcpkg expects it
file(COPY ${SOURCE_PATH}/doc/license-bsd.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/g2o/)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/g2o/license-bsd.txt ${CURRENT_PACKAGES_DIR}/share/g2o/copyright)

vcpkg_fixup_cmake_targets()
