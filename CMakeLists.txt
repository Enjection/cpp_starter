cmake_minimum_required(VERSION 3.15)

project(starter_app
        LANGUAGES
        CXX
        VERSION
        0.0.1
        )
include(cmake/StandardProjectSettings.cmake)
include(cmake/PreventInSourceBuilds.cmake)
include(cmake/Version.cmake)
GenVersion(
        IN
        ${CMAKE_CURRENT_SOURCE_DIR}/pkg_version/pkg_version.h.in
        OUT
        ${CMAKE_BINARY_DIR}/pkg_version/pkg_version.h
        VERSION_STRING
        ${CMAKE_PROJECT_VERSION}
)

# Link this 'library' to set the c++ standard / compile-time options requested
add_library(project_options INTERFACE)
target_compile_features(project_options INTERFACE cxx_std_17)

# Link this 'library' to use the warnings specified in CompilerWarnings.cmake
add_library(project_warnings INTERFACE)

# enable cache system
include(cmake/Cache.cmake)

# standard compiler warnings
include(cmake/CompilerWarnings.cmake)
set_project_warnings(project_warnings)

# sanitizer options if supported by compiler
include(cmake/Sanitizers.cmake)
enable_sanitizers(project_options)

# enable doxygen
include(cmake/Doxygen.cmake)
enable_doxygen()

# allow for static analysis options
include(cmake/StaticAnalyzers.cmake)

option(
        BUILD_SHARED_LIBS
        "Enable compilation of shared libraries"
        OFF)

option(
        ENABLE_TESTING
        "Enable Test Builds"
        ON)

option(
        ENABLE_FUZZING
        "Enable Fuzzing Builds"
        OFF)

option(
        ENABLE_PCH
        "Enable Precompiled Headers"
        OFF)

option(
        ENABLE_UNITY_BUILDS
        "Enable Unity builds of projects"
        OFF)

option(
        ENABLE_BUILD_UTILS
        "Enable building of additional utils"
        ON)

option(
        ENABLE_STATIC_BUILD
        "Enable static build"
        ON)

option(
        ENABLE_FULL_BUILD
        "Enable full build"
        OFF)

if (ENABLE_STATIC_BUILD)
    #set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -static-libgcc -static-libstdc++")
endif ()

if (ENABLE_PCH)
    # This sets a global PCH parameter, each project will build its own PCH, which is a good idea if any #define's change
    #
    # consider breaking this out per project as necessary
    target_precompile_headers(
            project_options
            INTERFACE
            <vector>
            <string>
            <map>
            <utility>)
endif ()

include(cmake/Conan.cmake)
run_conan()

if (ENABLE_FULL_BUILD)
    conan_cmake_run(CONANFILE conanfile.py
            BASIC_SETUP CMAKE_TARGETS
            BUILD all)
else ()
    conan_cmake_run(CONANFILE conanfile.py
            BASIC_SETUP CMAKE_TARGETS
            BUILD outdated)
endif ()

if (ENABLE_TESTING)
    enable_testing()
    message("Building Tests...")
    add_subdirectory(test)
endif ()

if (ENABLE_FUZZING)
    message("Building Fuzz Tests...")
    add_subdirectory(fuzz_test)
endif ()

add_subdirectory(third_party)

add_library(project_version INTERFACE)

add_dependencies(project_version check_git_repository)

target_include_directories(project_version
        INTERFACE
        ${CMAKE_BINARY_DIR}/pkg_version)

add_subdirectory(app)

if (ENABLE_BUILD_UTILS)
    add_subdirectory(utils)
endif ()

if (ENABLE_UNITY_BUILDS)
    set_target_properties(${PROJECT_NAME} PROPERTIES UNITY_BUILD ON)
endif ()
