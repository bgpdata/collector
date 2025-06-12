# cmake file for collectord

# Define the version
set (COLLECTOR_VER_MAJOR "0")
set (COLLECTOR_VER_MINOR "16")
set (COLLECTOR_VER_PATCH "0")
set (COLLECTOR_VER_RELEASE "1")
set (COLLECTORD_VERSION "${COLLECTOR_VER_MAJOR}.${COLLECTOR_VER_MINOR}.${COLLECTOR_VER_PATCH}-${COLLECTOR_VER_RELEASE}")

cmake_minimum_required (VERSION 2.6)
project (COLLECTOR)

# find and include boost
find_package( Boost 1.41.0 REQUIRED)
   if(Boost_FOUND)
      include_directories(${Boost_INCLUDE_DIRS})
  endif()

# Configure the version for compiling
configure_file( collectord_version.h.in ${CMAKE_BINARY_DIR}/generated/collectord_version.h )
include_directories( ${CMAKE_BINARY_DIR}/generated/ ) 

if (CMAKE_SYSTEM_NAME STREQUAL Linux)
    set(LINUX TRUE)
elseif (CMAKE_SYSTEM_NAME STREQUAL Darwin)
    set(MACOSX TRUE)
else ()
    Message (FATAL_ERROR "${CMAKE_SYSTEM_NAME} not supported; Must be Linux or Darwin")
endif()

# Add the Server directory
add_subdirectory (Server)



