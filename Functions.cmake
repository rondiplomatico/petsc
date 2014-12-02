# Tries to compile given source code (of given type) and 
function(trycompile RES_VAR INCS CODE EXT)
    # This check makes sure the variable is not already in the cache
    if("${RES_VAR}" MATCHES "^${RES_VAR}$")
        message(STATUS "Compiling code to check for ${RES_VAR}")
        SET(BINDIR ${CMAKE_CURRENT_BINARY_DIR}/trycompile)
        file(MAKE_DIRECTORY ${BINDIR})
        STRING(RANDOM LENGTH 6 SALT)
        SET(SOURCEFILE ${BINDIR}/trycompile_${RES_VAR}_${SALT}.${EXT})
        if (${EXT} STREQUAL "c" OR ${EXT} STREQUAL "cpp")
            SET(STUB "@INCS@\nint main(int argc, char **argv) {\n@CODE@\nreturn 0;\n}")
        elseif(${EXT} STREQUAL "f" OR ${EXT} STREQUAL "f90")
            SET(STUB "@INCS@\nprogram TESTFortran\n@CODE@\nend program TESTFortran")
        else()
            message(FATAL_ERROR "Not implemented: extension '${EXT}'")
        endif()
        file(WRITE ${SOURCEFILE} "${STUB}")
        configure_file(${SOURCEFILE} ${SOURCEFILE} @ONLY)
        try_compile(${RES_VAR} ${BINDIR}
                SOURCES ${SOURCEFILE}
                ${ARGN})
        set(${RES_VAR} ${${RES_VAR}} CACHE INTERNAL "Try compile test for ${RES_VAR}")
        set(${RES_VAR} ${${RES_VAR}} PARENT_SCOPE)
        message(STATUS "Compiling code to check for ${RES_VAR} .. ${${RES_VAR}}")
        #file(REMOVE ${SOURCEFILE})
    endif()
endfunction()

include(CheckFunctionExists)
function(checkexists RES_VAR FUNC)
    #message(STATUS "Checking if ${FUNC} exists")
    if (${ARGC} GREATER 0 AND NOT "${ARGN}" STREQUAL "")
        #message(STATUS "Looking in extra libraries ${ARGN}")
        SET(CMAKE_REQUIRED_LIBRARIES ${ARGN})
    endif()
    SET(CMAKE_REQUIRED_DEFINITIONS -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER})
    CHECK_FUNCTION_EXISTS(${FUNC} ${RES_VAR})
    set(${RES_VAR} ${${RES_VAR}} PARENT_SCOPE)
    #message(STATUS "Checking if ${FUNC} exists .. ${RESULT_VAR}")
endfunction()

include(CheckFortranFunctionExists)
function(checkfexists RES_VAR FUNC)
    #message(STATUS "Checking if Fortran ${FUNC} exists")
    if (${ARGC} GREATER 0 AND NOT ${ARGN} STREQUAL "")
        #message(STATUS "Looking in extra libraries ${ARGN}")
        SET(CMAKE_REQUIRED_LIBRARIES ${ARGN})
    endif()
    SET(CMAKE_REQUIRED_DEFINITIONS -DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER})
    CHECK_FORTRAN_FUNCTION_EXISTS(${FUNC} ${RES_VAR})
    set(${RES_VAR} ${${RES_VAR}} PARENT_SCOPE)
    #message(STATUS "Checking if ${FUNC} exists .. ${RESULT_VAR}")
endfunction()