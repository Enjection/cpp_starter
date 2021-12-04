add_library(
        ${PROJECT_NAME}_core

        include/application.h
        src/application.cpp
)

target_include_directories(
        ${PROJECT_NAME}_core

        PUBLIC
        include
)

target_link_libraries(
        ${PROJECT_NAME}_core

        PUBLIC

        CONAN_PKG::libuv

        PRIVATE

        project_options
        project_warnings
        project_version
)

add_executable(
    ${PROJECT_NAME}
    src/main.cpp
)


target_link_libraries(
        ${PROJECT_NAME}
        PUBLIC

        ${PROJECT_NAME}_core
)
