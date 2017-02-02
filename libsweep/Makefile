include config.mk

all: buildOutputDirs $(BIN_DIR)/$(target)

print:
	echo CC=$(CC) CFLAGS=$(CFLAGS)

# Creates the output directories for the generated files
buildOutputDirs:
	$(MKDIR_P) $(BIN_DIR)
	$(MKDIR_P) $(OBJ_ARCH_DIR)

# Sweep library .dll or .so (encoded by $(target))
$(BIN_DIR)/$(target): $(OBJ_FILES)
	$(LINKER) $(CFLAGS) $(LDFLAGS) $^ -o $@ $(LDLIBS)

# Object files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) $(LDFLAGS) $(INC_DIRS) -c $< -o $@

# Create the output directories, and then build the dummy
dummy: buildOutputDirs dummy_build

dummy_build: $(DUMMY_OBJ_FILES)
	$(LINKER) $(CFLAGS) $(LDFLAGS) -o $(BIN_DIR)/$(target) $^ $(LDLIBS)

install:
	$(MKDIR_P) $(INSTALL_DIR_INCLUDES)
	install -m 0644 $(INC_DIR)/sweep.h $(INSTALL_DIR_INCLUDES)
	install -m 0644 $(INC_DIR)/sweep.hpp $(INSTALL_DIR_INCLUDES)
	$(MKDIR_P) $(INSTALL_DIR_LIB)
	install -m 0644 $(BIN_DIR)/$(target) $(INSTALL_DIR_LIB)
	ln -sf $(INSTALL_DIR_LIB)/$(target) $(INSTALL_DIR_LIB)/$(target).$(VERSION_MAJOR)
	ln -sf $(INSTALL_DIR_LIB)/$(target) $(INSTALL_DIR_LIB)/$(target).$(VERSION_MAJOR).$(VERSION_MINOR)

watch:
	while ! inotifywait -e modify *.c *.h; do make; done

clean:
	@$(RM) *.so *.o *.dll
	@$(RM) -rf bin obj

.PHONY: clean install watch
