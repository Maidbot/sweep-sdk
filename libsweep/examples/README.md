# Libsweep Examples

Examples for the `libsweep` library.

Requires `libsweep.dll` to be installed. This should be installed somewhere on the user environment variable "PATH". `libsweep.dll` could be placed (installed) in `"C:\MinGW\bin"` for example.
This can be either the dummy library always returning static point cloud data or the device library requiring the Scanse Sweep device to be plugged in.

### Quick Start

To build: 

```bash
    # build the examples
    mkdir build
    cd build
    # generate the make file (assumes you are using MSYS terminal for MinGW)
    cmake -G "MSYS Makefiles" .. 
    # run the makefile
    cmake --build .
```

**Note:** running the example requires the `libsweep.dll` be installed (ex: `C:\MinGW\bin`), or at least placed in the same directory as the executable (`examples\build`).


```bash
    # run the c example
    ./example-c
    # run the c++ example
    ./example-c++
```

### License

Copyright © 2016 Daniel J. Hofmann

Distributed under the MIT License (MIT).
