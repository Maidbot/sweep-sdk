include config.mk

all: $(target)

print:
	echo CC=$(CC) CFLAGS=$(CFLAGS)

libsweep.so: sweep.o protocol.o serial_unix.o time_unix.o
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)

libsweep.dll: sweep.o protocol.o serial_win.o time_win.o
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)

dummy: dummy.o time_unix.o
	$(CC) $(LDFLAGS) -o libsweep.so $^ $(LDLIBS)
dummy_win: dummy.o time_win.o
	$(CC) $(LDFLAGS) -o libsweep.so $^ $(LDLIBS)

install:
	mkdir -p $(PREFIX)\include\sweep
	install -m 0644 sweep.h $(PREFIX)\include\sweep
	install -m 0644 sweep.hpp $(PREFIX)\include\sweep
	mkdir -p $(PREFIX)\bin
	install -m 0644 libsweep.dll $(PREFIX)\bin
	ln -sf $(PREFIX)\bin\libsweep.dll $(PREFIX)\bin\libsweep.dll.$(VERSION_MAJOR)
	ln -sf $(PREFIX)\bin\libsweep.dll $(PREFIX)\bin\libsweep.dll.$(VERSION_MAJOR).$(VERSION_MINOR)

watch:
	while ! inotifywait -e modify *.c *.h; do make; done

clean:
	@$(RM) *.so *.o *.dll

.PHONY: clean install watch
