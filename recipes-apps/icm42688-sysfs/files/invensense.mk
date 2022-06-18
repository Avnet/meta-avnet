# Clear variables
INV_CFLAGS :=
INV_INCLUDES :=
INV_SRCS :=

# Version
INV_VERSION_MAJOR := 9
INV_VERSION_MINOR := 4
INV_VERSION_PATCH := 1
INV_VERSION_SUFFIX := -simple-android-linux-test2
$(info InvenSense version MA-$(INV_VERSION_MAJOR).$(INV_VERSION_MINOR).$(INV_VERSION_PATCH)$(INV_VERSION_SUFFIX))
INV_CFLAGS += -DINV_VERSION_MAJOR=$(INV_VERSION_MAJOR)
INV_CFLAGS += -DINV_VERSION_MINOR=$(INV_VERSION_MINOR)
INV_CFLAGS += -DINV_VERSION_PATCH=$(INV_VERSION_PATCH)
INV_CFLAGS += -DINV_VERSION_SUFFIX=\"$(INV_VERSION_SUFFIX)\"

# InvenSense chip type
ifndef INVENSENSE_CHIP
$(info missing INVENSENSE_CHIP, select from: iam20680, icm20602, icm20690, icm42600, icm42686, icm42688, icm40609d, icm43600)
$(info Note: select icm42600 for icm40607, select icm43600 for icm42607 & icm42670)
$(warning Using by default iam20680)
#INVENSENSE_CHIP := iam20680
INVENSENSE_CHIP := icm42688
endif
$(info InvenSense chip = $(INVENSENSE_CHIP))

# Batch mode support
ifeq (,$(filter $(INVENSENSE_CHIP), iam20680))
INV_CFLAGS += -DBATCH_MODE_SUPPORT
endif

# ODR configuration according to chip type
# Define for devices with SMPLRT_DIV register
ifneq (,$(filter $(INVENSENSE_CHIP), iam20680 icm20602 icm20690))
INV_CFLAGS += -DODR_SMPLRT_DIV
endif

# Enhanced Accel FSR support (32g)
ifneq (,$(filter $(INVENSENSE_CHIP), icm42686 icm40609d))
INV_CFLAGS += -DACCEL_ENHANCED_FSR_SUPPORT
endif

# Enhanced Gyro FSR support (4000dps)
ifneq (,$(filter $(INVENSENSE_CHIP), icm42686))
INV_CFLAGS += -DGYRO_ENHANCED_FSR_SUPPORT
endif

# FIFO high resolution mode
ifneq (,$(filter $(INVENSENSE_CHIP), icm42686 icm42688))
INV_CFLAGS += -DFIFO_HIGH_RES_ENABLE
endif

# Compass support
# Set true to support Compass
COMPASS_SUPPORT := false
ifeq ($(COMPASS_SUPPORT), true)
INV_CFLAGS += -DCOMPASS_SUPPORT
endif
$(info InvenSense Compass support = $(COMPASS_SUPPORT))

# Pressure support
# Set true to support Pressure
PRESSURE_SUPPORT := false
ifeq ($(findstring icp, $(INVENSENSE_PRI_SENSORS)), icp)
PRESSURE_SUPPORT := true
endif
ifeq ($(PRESSURE_SUPPORT), true)
INV_CFLAGS += -DPRESSURE_SUPPORT
endif
$(info InvenSense Pressure support = $(PRESSURE_SUPPORT))

INV_SRCS += SensorsMain.cpp
INV_SRCS += SensorBase.cpp
INV_SRCS += MPLSensor.cpp
INV_SRCS += MPLSupport.cpp
ifeq ($(COMPASS_SUPPORT), true)
INV_SRCS += CompassSensor.IIO.primary.cpp
endif
ifeq ($(PRESSURE_SUPPORT), true)
INV_SRCS += PressureSensor.IIO.primary.cpp
endif

INV_INCLUDES += tools
INV_SRCS += tools/inv_sysfs_utils.c
INV_SRCS += tools/inv_iio_buffer.c
INV_SRCS += tools/ml_sysfs_helper.c
