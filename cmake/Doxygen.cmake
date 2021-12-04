function(enable_doxygen)
    option(ENABLE_DOXYGEN "Enable doxygen doc builds of source" OFF)
    if (ENABLE_DOXYGEN)
        set(DOXYGEN_CALLER_GRAPH YES)
        set(DOXYGEN_CALL_GRAPH YES)
        set(DOXYGEN_EXTRACT_ALL YES)
        set(DOXYGEN_USE_MDFILE_AS_MAINPAGE README.md)
        set(DOXYGEN_DISTRIBUTE_GROUP_DOC YES)
        find_package(Doxygen REQUIRED dot)
        doxygen_add_docs(
                doxygen-docs
                ${PROJECT_SOURCE_DIR}
                README.md)

    endif ()
endfunction()
