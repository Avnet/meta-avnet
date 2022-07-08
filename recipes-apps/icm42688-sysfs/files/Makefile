# HAL source files location
HAL_SRC_DIR := ./

include $(HAL_SRC_DIR)/invensense.mk

# Compiler flags
CFLAGS += -O2
CFLAGS += -Wall -Wextra -Werror
CFLAGS += -std=gnu11
CFLAGS += $(INV_CFLAGS)

# source C files
SRC_C_FILES += test-sensors-sysfs.c

# include dirs
CFLAGS += $(foreach inc, $(INV_INCLUDES), -I$(HAL_SRC_DIR)/$(inc))

# test application
APP = icm42688-sysfs

# Add any other object files to this list below
#APP_OBJS = icm42688-sysfs.o
APP_OBJS = test-sensors-sysfs.o

all: build

build: $(APP)

$(APP): $(APP_OBJS)
	$(CC) -o $@ $(APP_OBJS) $(LDFLAGS) $(LDLIBS) $(CFLAGS)
clean:
	rm -f $(APP) *.o

