cmake_minimum_required(VERSION 2.8)

enable_language(CXX)
SET(CMAKE_CXX_FLAGS "-Wall -ansi -pedantic -std=c++0x")

#cmake_policy(SET CMP0015 NEW)

# Add and compile the gtest library
set(gtest_src ../gtest)
set(gtest_binary_dir googletest)
set(gtest_include ${gtest_src}/include/)
include_directories(${gtest_include})
message("gtest include directory ${gtest_include}")
add_subdirectory(../gtest ${gtest_binary_dir})
set(gtest_libs gtest gtest_main)
message("gtest_libs ${gtest_libs}")

# set the mcpele include directory
set(mcpele_include ../../source)
include_directories(${mcpele_include})
message("mcpele include directory ${mcpele_include}")

# build the mcpele library
FILE(GLOB mcpele_sources ${mcpele_include}/mcpele/*.cpp)
add_library(mcpele_lib ${mcpele_sources})

# set the pele include directory
set(pele_include ../../../pele/source CACHE STRING "the pele c++ source directory")
if (EXISTS ${pele_include}/pele/array.h)
  message("pele include directory: ${pele_include}")
else()
  message(FATAL_ERROR "pele include directory is not correct: ${pele_include} : use ccmake to set it")
endif()
include_directories(${pele_include})

# build the pele library
FILE(GLOB pele_sources ${pele_include}/*.cpp)
add_library(pele_lib ${pele_sources})

# get all the source files
FILE(GLOB sources *.cpp)

add_executable(test_main ${sources})
target_link_libraries(test_main mcpele_lib pele_lib gtest gtest_main pthread)
