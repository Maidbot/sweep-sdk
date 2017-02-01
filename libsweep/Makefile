include config.mk


#all: $(target)
all: buildOutputDirs $(target)

print:
	echo CC=$(CC) CFLAGS=$(CFLAGS)

# creates the output directories for the generated files
buildOutputDirs:
	$(MKDIR_P) $(BIN_DIR)
	$(MKDIR_P) $(OBJ_ARCH_DIR)

# sweep library .so
#libsweep.so: sweep.o protocol.o serial_unix.o time_unix.o
#	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)

# sweep library dll
$(BIN_DIR)/libsweep.dll: $(OBJ_FILES)
	$(LINKER)  $(CFLAGS) $(LDFLAGS) $^ -o $@ 
	
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) $(LDFLAGS) $(INC_DIRS) -c $< -o $@

#dummy: dummy.o time_unix.o
#	$(CC) $(LDFLAGS) -o libsweep.so $^ $(LDLIBS)
#dummy_win: dummy.o time_win.o
#	$(CC) $(LDFLAGS) -o libsweep.so $^

install:
	$(MKDIR_P) $(PREFIX)\include\sweep
	install -m 0644 $(INC_DIR)\sweep.h $(PREFIX)\include\sweep
	install -m 0644 $(INC_DIR)\sweep.hpp $(PREFIX)\include\sweep
	$(MKDIR_P) $(PREFIX)\bin
	install -m 0644 $(target) $(PREFIX)\bin
	ln -sf $(PREFIX)\bin\libsweep.dll $(PREFIX)\bin\libsweep.dll.$(VERSION_MAJOR)
	ln -sf $(PREFIX)\bin\libsweep.dll $(PREFIX)\bin\libsweep.dll.$(VERSION_MAJOR).$(VERSION_MINOR)

watch:
	while ! inotifywait -e modify *.c *.h; do make; done

clean:
	@$(RM) *.so *.o *.dll
	@$(RM) -rf bin obj

.PHONY: clean install watch
