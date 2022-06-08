cmake_minimum_required(VERSION 3.17)

project(advtr-clr)
enable_language(OBJC)

set(NAME advtr-clr)
set(CMAKE_C_FLAGS "-x objective-c")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin)

set(HEADERFILES
        ./src/ADVColor.h
        ./src/ADVColorPalette.h
        ./src/NSDictionary+Flatten.h
        ./src/ADVArgBoolean.h
        ./src/ADVArgParser.h
        ./src/Flatten.h
        ./src/ADVUtils.h
        ./src/ADVLogger.h
        ./src/rgba.h
)

set(SOURCEFILES
        ./src/ADVColor.m
        ./src/ADVColorPalette.m
        ./src/NSDictionary+Flatten.m
        ./src/ADVArgBoolean.m
        ./src/ADVArgParser.m
        ./src/Flatten.m
        ./src/ADVUtils.m
        ./src/rgba.m
)

add_executable(
        advtr-clr
        ./src/main.m
        ${HEADERFILES}
        ${SOURCEFILES}
)

target_link_libraries(${NAME}
        "-framework Cocoa"
        "-framework AppKit"
        "-framework Foundation"
        "-framework CoreImage"
)
