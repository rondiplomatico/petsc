set (PETSC_HAVE_C2HTML NO)
set (PETSC_USING_F90 YES)
set (PETSC_USING_F2003 YES)
if (MINGW OR WIN32)
    set(PETSC_HAVE_MPI_F90MODULE NO)
elseif()
    set(PETSC_HAVE_MPI_F90MODULE YES)
endif()
set (PETSC_SIGNAL_CAST  )
set (PETSC_USE_ISATTY YES)
set (PETSC_USE_SINGLE_LIBRARY 1)
set (PETSC_USE_INFO YES)
set (PETSC_USE_BACKWARD_LOOP 1)
set (PETSC_USE_LOG YES)
set (PETSC_USE_CTABLE 1)
set (PETSC_USE_COMPLEX NO)
set (PETSC_USE_REAL_DOUBLE YES)
set (PETSC_CLANGUAGE_C YES)

if (NOT WIN32)
    find_library (PETSC_DL_LIB dl HINTS "/usr/lib/gcc/x86_64-linux-gnu/4.6" "/lib/x86_64-linux-gnu" "/usr/lib/x86_64-linux-gnu" )
endif()
set(PETSC_PACKAGE_LIBS ${PETSC_DL_LIB})
set(PETSC_PACKAGE_INCLUDES )

# New variables in petsc 3.6.1
set (PETSC_HAVE_HWLOC YES)
# This is only used to check if the mpi in a third party program consuming petsc is the same as the one used to build petsc.
#set (PETSC_HAVE_OMPI_MINOR_VERSION 6)
#set (PETSC_HAVE_OMPI_MAJOR_VERSION 1)
#set (PETSC_HAVE_OMPI_RELEASE_VERSION 5)