cmake_minimum_required(VERSION 3.26)
project(sem11_llvm_hw05)

set(CMAKE_C_STANDARD 99)
set(CMAKE_CXX_STANDARD 17)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/third-party/antlr4/runtime/Cpp/cmake")

find_package(LLVM REQUIRED)
find_package(ANTLR REQUIRED)
add_subdirectory(third-party/antlr4/runtime/Cpp)
add_subdirectory(hw01)

antlr_target(MyLanguage MyLanguage.g4 VISITOR)

add_definitions(${LLVM_DEFINITIONS})
include_directories(
  hw01
  ${LLVM_INCLUDE_DIRS}
  third-party/antlr4/runtime/Cpp/runtime/src
  ${ANTLR_MyLanguage_OUTPUT_DIR})

add_executable(gen gen.cpp ${ANTLR_MyLanguage_CXX_OUTPUTS})
target_link_directories(gen PRIVATE ${LLVM_LIBRARY_DIRS})
target_link_libraries(gen LLVM antlr4_static)
