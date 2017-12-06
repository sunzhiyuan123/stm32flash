CC=arm-hisiv600-linux-gcc
AR=arm-hisiv600-linux-ar
PREFIX = $(PWD)
CFLAGS  += -Wall -g -O3
CFLAGS  += -mcpu=cortex-a17.cortex-a7 -mfloat-abi=softfp -mfpu=neon-vfpv4 -mno-unaligned-access -fno-aggressive-loop-optimizations -ffunction-sections -fdata-sections
LDFLAGS += -mcpu=cortex-a17.cortex-a7 -mfloat-abi=softfp -mfpu=neon-vfpv4 -mno-unaligned-access -fno-aggressive-loop-optimizations

export CC AR CFLAGS

INSTALL = install

OBJS =	dev_table.o	\
	i2c.o		\
	init.o		\
	main.o		\
	port.o		\
	serial_common.o	\
	serial_platform.o	\
	stm32.o		\
	utils.o

LIBOBJS = parsers/parsers.a

all: stm32flash

serial_platform.o: serial_posix.c serial_w32.c

parsers/parsers.a: force
	cd parsers && $(MAKE) parsers.a

stm32flash: $(OBJS) $(LIBOBJS)
	$(CC) $(LDFLAGS) -o $@ $(OBJS) $(LIBOBJS)

clean:
	rm -f $(OBJS) stm32flash
	cd parsers && $(MAKE) $@

install: all
	$(INSTALL) -d $(DESTDIR)$(PREFIX)/bin
	$(INSTALL) -m 755 stm32flash $(DESTDIR)$(PREFIX)/bin
	$(INSTALL) -d $(DESTDIR)$(PREFIX)/share/man/man1
	$(INSTALL) -m 644 stm32flash.1 $(DESTDIR)$(PREFIX)/share/man/man1

force:

.PHONY: all clean install force
