cmake_minimum_required(VERSION 3.26)
project(sem11_llvm_hw03)

set(CMAKE_C_STANDARD 99)
set(CMAKE_CXX_STANDARD 17)

find_package(LLVM REQUIRED)
add_subdirectory(hw01)

add_definitions(${LLVM_DEFINITIONS})
include_directories(hw01 ${LLVM_INCLUDE_DIRS})

add_executable(gen gen.cpp gen.hpp)
target_link_directories(gen PRIVATE ${LLVM_LIBRARY_DIRS})
target_link_libraries(gen LLVM)
