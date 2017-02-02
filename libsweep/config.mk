VERSION_MAJOR = 0
VERSION_MINOR = 1

# project directory containing src files
SRC_DIR := src
# project directory containing include header files
INC_DIR := inc
# created directory where object files will be placed
OBJ_DIR := obj
# created directory where outputs will be placed
BIN_DIR := bin

# Define some commands (these might need to change depending on platform)
MKDIR_P := mkdir -p

# read the operating system
UNAME := $(shell uname -s)

# Note if the uname indicates any form of MINGW32 on windows
ifeq ($(findstring MINGW32,$(UNAME)),MINGW32)
  #if UNAME contains MINGW32
  UNAME = MINGW
else ifeq ($(findstring MSYS,$(UNAME)),MSYS)
  #if UNAME contains MSYS
  UNAME = MINGW
endif

# Set Options & Flags by Operating System
ifeq ($(UNAME), Linux)
  # For linux platforms
  target = libsweep.so
  dummy_target = dummy_linux
  SRC_ARCH_DIR := src/arch/unix
  INSTALL_DIR_LIB ?= /usr/lib
  INSTALL_DIR_INCLUDES ?= /usr/include/sweep
  LINKER = cc
  CFLAGS += -O2 -Wall -Wextra -pedantic -std=c99 -Wnonnull -fvisibility=hidden -fPIC -pthread
  LDFLAGS += -shared -Wl,-soname,libsweep.so.$(VERSION_MAJOR)
  LDLIBS += -lpthread
else ifeq ($(UNAME), Darwin)
  # For mac platforms
  $(error macOS build system support missing)
else ifeq ($(UNAME), MINGW)
  # For win platforms using MinGW
  target = libsweep.dll
  dummy_target = dummy_win
  SRC_ARCH_DIR := src/arch/win
  INSTALL_DIR_LIB ?= C:/MinGW/bin
  INSTALL_DIR_INCLUDES ?= C:/MinGW/include/sweep
  CC = gcc
  LINKER = gcc
  CFLAGS += -O2 -Wall -Wextra -pedantic -std=c99 -Wnonnull -fvisibility=hidden -mno-ms-bitfields
  LDFLAGS += -shared -Wl,-soname,libsweep.dll.$(VERSION_MAJOR)
else
  # For all other platforms
  $(error system not supported)
endif

# Specify compiler should look in the inc directory for user-written header files
INC_DIRS := -I$(INC_DIR)

# Specify the platform specific architecture subfolders to be made in the obj directory
OBJ_ARCH_DIR = $(patsubst $(SRC_DIR)/%,$(OBJ_DIR)/%, $(SRC_ARCH_DIR))

# Generate Lists of project filenames...
# First specify the src files (both general and platform specific)
SRC_FILES := $(wildcard $(SRC_DIR)/*.c)
SRC_FILES += $(wildcard $(SRC_ARCH_DIR)/*.c)

# remove the dummy file from the src files, and add it to its own variable
SRC_FILES := $(filter-out $(SRC_DIR)/dummy.c, $(SRC_FILES))
DUMMY_SRC_FILES := $(SRC_DIR)/dummy.c $(wildcard $(SRC_ARCH_DIR)/time_*.c)


# Then specify the obj files according to the structure of src 
# ie: (src/arch/win/file_win.c -> obj/arch/win/file_win.o)
OBJ_FILES := $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRC_FILES))
DUMMY_OBJ_FILES := $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(DUMMY_SRC_FILES))