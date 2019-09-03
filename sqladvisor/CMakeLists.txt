cmake_minimum_required (VERSION 2.6)
project(sqladvisor)

# /usr/local/sqlparser为sqlparser库安装目录，必要时进行修改
include_directories("/usr/local/sqlparser/include")
include_directories("/usr/local/sqlparser/include/regex")
include_directories("/usr/lib64/glib-2.0/include")
include_directories("/usr/include/glib-2.0")
include_directories("/usr/lib/x86_64-linux-gnu/glib-2.0/include")
link_directories("/usr/local/sqlparser/lib")
link_directories("/usr/lib64")

set(TEST_SRC main.cc)
add_executable(sqladvisor ${TEST_SRC})

target_link_libraries(sqladvisor sqlparser)
target_link_libraries(sqladvisor perconaserverclient_r)
target_link_libraries(sqladvisor glib-2.0)
