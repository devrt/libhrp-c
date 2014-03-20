TARGET = libhrp-c-stubskel.a
IDL_DIR = ./idl/
IDLS := $(wildcard $(IDL_DIR)*.idl)
INCLUDES := $(patsubst $(IDL_DIR)%.idl,%.h,$(IDLS))
STUBS := $(patsubst %.h,%-stubs.o,$(INCLUDES))
COMMON := $(patsubst %.h,%-common.o,$(INCLUDES))
OBJS := $(STUBS) $(COMMON)

CFLAGS = -c -O2 `pkg-config --cflags ORBit-2.0`
CC     = gcc
LD     = ld
AR     = ar
IDLC   = orbit-idl-2

all: $(OBJS) $(INCLUDES)
	$(AR) rcs $(TARGET) $(OBJS)

%.o: %.c
	$(CC) $(CFLAGS) $< -o $@

%-stubs.c %-skels.c %-common.c: %.h
	true

%.h: $(IDL_DIR)%.idl
	$(IDLC) --showcpperrors $<

clean:
	rm *.o *.c *.h $(TARGET)

