VERSION_MAJOR = 0
VERSION_MINOR = 1

# read the operating system
UNAME := $(shell uname -s)

# check if the uname indicates MINGW32 on windows
ifeq ($(findstring MINGW32,$(UNAME)),MINGW32)
  #if UNAME contains MINGW32
  UNAME = MINGW
else ifeq ($(findstring MSYS,$(UNAME)),MSYS)
  #if UNAME contains MSYS
  UNAME = MINGW
endif

# Set Options + Flags by Operating System
ifeq ($(UNAME), Linux)
  # For linux platforms
  target = libsweep.so
  PREFIX ?= /usr
  CFLAGS += -O2 -Wall -Wextra -pedantic -std=c99 -Wnonnull -fvisibility=hidden -fPIC -pthread
  LDFLAGS += -shared -Wl,-soname,libsweep.so.$(VERSION_MAJOR)
  LDLIBS += -lpthread
else ifeq ($(UNAME), Darwin)
  # For mac platforms
  $(error macOS build system support missing)
else ifeq ($(UNAME), MINGW)
  # For win platforms using MinGW
  target = libsweep.dll
  PREFIX ?= C:\MinGW
  CC = gcc
  CFLAGS += -O2 -Wall -Wextra -pedantic -std=c99 -Wnonnull -fvisibility=hidden -fPIC -mno-ms-bitfields
  LDFLAGS += -shared -Wl,-soname,libsweep.dll.$(VERSION_MAJOR)
else
  # For all other platforms
  $(error system not supported)
endif
