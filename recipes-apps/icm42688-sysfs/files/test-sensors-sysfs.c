/*
 * Copyright (C) 2018-2020 InvenSense, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <stdio.h>
#include <stdbool.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdint.h>
#include <inttypes.h>
#include <poll.h>
#include <unistd.h>
#include <signal.h>
#include <stdlib.h>
#include <time.h>
#include <getopt.h>
#include <math.h>
#include <string.h>

#define VERSION_STR             "1.1.1"
#define USAGE_NOTE              ""

#define IIO_BUFFER_LENGTH       32768
#define NS_IN_SEC               1000000000LL

/* char device for sensor data */
#define IIO_DEVICE              "/dev/iio:device%lu"

/* sysfs to control chip */
#define SYSFS_PATH              "/sys/bus/iio/devices/iio:device%lu"
#define SYSFS_CHIP_NAME         "name"
#define SYSFS_CHIP_ENABLE       "buffer/enable"
#define SYSFS_BUFFER_LENGTH     "buffer/length"
#define SYSFS_TIMESTAMP_EN      "scan_elements/in_timestamp_en"
#define SYSFS_TIMESTAMP_INDEX   "scan_elements/in_timestamp_index"
#define SYSFS_TIMESTAMP_TYPE    "scan_elements/in_timestamp_type"
#define SYSFS_GYRO_ORIENT       "info_anglvel_matrix"
#define SYSFS_GYRO_FIFO_ENABLE  "in_anglvel_enable"
#define SYSFS_GYRO_FSR          "in_anglvel_scale"
#define SYSFS_GYRO_RATE         "in_anglvel_rate"
#define SYSFS_ACCEL_ORIENT      "info_accel_matrix"
#define SYSFS_ACCEL_FIFO_ENABLE "in_accel_enable"
#define SYSFS_ACCEL_FSR         "in_accel_scale"
#define SYSFS_ACCEL_RATE        "in_accel_rate"
#define SYSFS_HIGH_RES_MODE     "in_high_res_mode"
#define SYSFS_BATCH_TIMEOUT     "misc_batchmode_timeout"

enum {
    SENSOR_ACCEL = 0,
    SENSOR_GYRO,
    SENSOR_NUM
};

enum {
    ACCEL_FSR_2G = 0,
    ACCEL_FSR_4G = 1,
    ACCEL_FSR_8G = 2,
    ACCEL_FSR_16G = 3,
    ACCEL_FSR_32G = 4       /* only for ICM42686, ICM40609D */
};

enum {
    GYRO_FSR_250DPS = 0,
    GYRO_FSR_500DPS = 1,
    GYRO_FSR_1000DPS = 2,
    GYRO_FSR_2000DPS = 3,
    GYRO_FSR_4000DPS = 4    /* only for ICM42686 */
};

/* update below for required FSR (except for FIFO high res mode chips) */
#define DEFAULT_ACCEL_FSR    ACCEL_FSR_8G
#define DEFAULT_GYRO_FSR     GYRO_FSR_2000DPS

/* iio sysfs path */
static char iio_sysfs_path[1024] = "";

/* iio device path */
static char iio_dev_path[1024] = "";

/* file descriptor for IIO_DEVICE */
static int iio_fd = -1;

/* saved timestamp for each sensor */
static int64_t accel_prev_ts;
static int64_t gyro_prev_ts;

/* last poll time used for batch mode */
static int64_t last_poll_time_ns;

/* batched sample number */
static int batched_sample_accel_nb;
static int batched_sample_gyro_nb;

/* for data from driver */
static char iio_read_buf[2048];
static int iio_read_size;

/* data header from driver */
#define ACCEL_HDR                1
#define GYRO_HDR                 2
#define EMPTY_MARKER             17
#define END_MARKER               18

#define ACCEL_DATA_SZ            24
#define GYRO_DATA_SZ             24
#define EMPTY_MARKER_SZ          8
#define END_MARKER_SZ            8

/* commandline options */
static const struct option options[] = {
    {"help", no_argument, NULL, 'h'},
    {"device", required_argument, NULL, 'd'},
    {"accel", required_argument, NULL, 'a'},
    {"gyro", required_argument, NULL, 'g'},
    {"convert", no_argument, NULL, 'c'},
    {"batch", required_argument, NULL, 'b'},
    {0, 0, 0, 0},
};

static const char *options_descriptions[] = {
    "Show this help and quit.",
    "Choose device by numero.",
    "Turn accelerometer on with ODR (Hz).",
    "Turn gyroscope on with ODR (Hz).",
    "Show data after unit conversion (m/s^2, rad/s)",
    "Set batch timeout in ms.",
};

/* get the current time */
static int64_t get_current_timestamp(void)
{
    struct timespec tp;

    clock_gettime(CLOCK_MONOTONIC, &tp);
    return  (int64_t)tp.tv_sec * 1000000000LL + (int64_t)tp.tv_nsec;
}

/* write a value to sysfs */
static int write_sysfs_int(char *attr, int data)
{
    FILE *fp;
    int ret;
    char path[1024];

    ret = snprintf(path, sizeof(path), "%s/%s", iio_sysfs_path, attr);
    if (ret < 0 || ret >= (int)sizeof(path)) {
        return -1;
    }

    ret = 0;
    printf("sysfs: %d -> %s\n", data, path);
    fp = fopen(path, "w");
    if (fp == NULL) {
        ret = -errno;
        printf("Failed to open %s\n", path);
    } else {
        if (fprintf(fp, "%d\n", data) < 0) {
            printf("Failed to write to %s\n", path);
            ret = -errno;
        }
        fclose(fp);
    }
    fflush(stdout);
    return ret;
}

/* read a value from sysfs */
static int read_sysfs_int(char *attr, int *data)
{
    FILE *fp;
    int ret;
    char path[1024];

    ret = snprintf(path, sizeof(path), "%s/%s", iio_sysfs_path, attr);
    if (ret < 0 || ret >= (int)sizeof(path)) {
        return -1;
    }

    ret = 0;
    fp = fopen(path, "r");
    if (fp == NULL) {
        ret = -errno;
        printf("Failed to open %s\n", path);
    } else {
        if (fscanf(fp, "%d", data) != 1) {
            printf("Failed to read %s\n", path);
            ret = -1;
        }
        fclose(fp);
    }
    printf("sysfs: %d <- %s\n", *data, path);
    fflush(stdout);
    return ret;
}

/* get sensor orientation from sysfs */
static int get_sensor_orient(int sensor, int *orient)
{
    char path[1024];
    FILE *fp;
    int ret;
    char *attr;

    if (sensor == SENSOR_ACCEL) {
        attr = SYSFS_ACCEL_ORIENT;
    } else if (sensor == SENSOR_GYRO) {
        attr = SYSFS_GYRO_ORIENT;
    } else {
        printf("invalid sensor type\n");
        fflush(stdout);
        return -1;
    }

    ret = snprintf(path, sizeof(path), "%s/%s", iio_sysfs_path, attr);
    if (ret < 0 || ret >= (int)sizeof(path)) {
        return -1;
    }

    ret = 0;
    fp = fopen(path, "r");
    if (fp == NULL) {
        printf("Failed to open %s\n", path);
        ret = -errno;
    } else {
        if (fscanf(fp, "%d,%d,%d,%d,%d,%d,%d,%d,%d",
                &orient[0], &orient[1], &orient[2],
                &orient[3], &orient[4], &orient[5],
                &orient[6], &orient[7], &orient[8]) != 9) {
            printf("Failed to read %s\n", path);
            ret = -1;
        }
        fclose(fp);
    }
    printf("%d,%d,%d,%d,%d,%d,%d,%d,%d\n",
            orient[0], orient[1], orient[2],
            orient[3], orient[4], orient[5],
            orient[6], orient[7], orient[8]);

    fflush(stdout);
    return ret;
}

/* get chip name from sysfs */
static int show_chip_name(void)
{
    FILE *fp;
    int ret;
    char name[256];
    char path[1024];

    ret = snprintf(path, sizeof(path), "%s/%s", iio_sysfs_path, SYSFS_CHIP_NAME);
    if (ret < 0 || ret >= (int)sizeof(path)) {
        return -1;
    }

    ret = 0;
    fp = fopen(path, "r");
    if (fp == NULL) {
        ret = -errno;
        printf("Failed to open %s\n", path);
    } else {
        if (fscanf(fp, "%s", name) != 1) {
            printf("Failed to read chip name\n");
            ret = -1;
        } else
            printf("chip : %s\n", name);
        fclose(fp);
    }
    fflush(stdout);
    return ret;
}

/* setup iio */
static int setup_iio(void)
{
    int ret;
    char path[1024];

    /* disable */
    ret = write_sysfs_int(SYSFS_CHIP_ENABLE, 0);
    if (ret)
        return ret;

    /* timestamp en */
    ret = write_sysfs_int(SYSFS_TIMESTAMP_EN, 1);
    if (ret)
        return ret;

    /* buffer length */
    ret = write_sysfs_int(SYSFS_BUFFER_LENGTH, IIO_BUFFER_LENGTH);
    if (ret)
        return ret;

    /* enable */
    ret = write_sysfs_int(SYSFS_CHIP_ENABLE, 1);
    if (ret)
        return ret;

    /* device */
    ret = snprintf(path, sizeof(path), "%s", iio_dev_path);
    if (ret < 0 || ret >= (int)sizeof(path)) {
        return -1;
    }

    iio_fd = open(iio_dev_path, O_RDONLY);
    if (iio_fd < 0) {
        printf("failed to open %s\n", iio_dev_path);
        fflush(stdout);
        return -errno;
    }

    return 0;
}

/* enable sensor through sysfs */
static int enable_sensor(int sensor, int en)
{
    int ret = 0;

    if (sensor == SENSOR_ACCEL) {
        ret = write_sysfs_int(SYSFS_ACCEL_FIFO_ENABLE, en);
    } else if (sensor == SENSOR_GYRO) {
        ret = write_sysfs_int(SYSFS_GYRO_FIFO_ENABLE, en);
    } else {
        printf("invalid sensor type\n");
    }
    fflush(stdout);
    return ret;
}

/* set odr through sysfs */
static int set_sensor_rate(int sensor, int hz)
{
    int ret = 0;

    if (sensor == SENSOR_ACCEL) {
        ret = write_sysfs_int(SYSFS_ACCEL_RATE, hz);
    } else if (sensor == SENSOR_GYRO) {
        ret = write_sysfs_int(SYSFS_GYRO_RATE, hz);
    } else {
        printf("invalid sensor type\n");
    }
    fflush(stdout);
    return ret;
}

/* set fsr through sysfs */
static int set_sensor_fsr(int sensor, int fsr)
{
    int ret = 0;

    if (sensor == SENSOR_ACCEL) {
        ret = write_sysfs_int(SYSFS_ACCEL_FSR, fsr);
    } else if (sensor == SENSOR_GYRO) {
        ret = write_sysfs_int(SYSFS_GYRO_FSR, fsr);
    } else {
        printf("invalid sensor type\n");
    }
    fflush(stdout);
    return ret;
}

/* get fsr through sysfs */
static int get_sensor_fsr(int sensor, int *fsr)
{
    int ret = 0;

    if (sensor == SENSOR_ACCEL) {
        ret = read_sysfs_int(SYSFS_ACCEL_FSR, fsr);
    } else if (sensor == SENSOR_GYRO) {
        ret = read_sysfs_int(SYSFS_GYRO_FSR, fsr);
    } else {
        printf("invalid sensor type\n");
    }
    fflush(stdout);
    return ret;
}

/* set batch timeout */
static int set_sensor_batch_timeout(int ms)
{
    return write_sysfs_int(SYSFS_BATCH_TIMEOUT, ms);
}

/* show usage */
static void usage(void)
{
    unsigned int i;

    printf("Usage:\n\t test-sensors-sysfs [-d <device_no>] [-a <rate>] [-g <rate>] [-c]"
            "\n\nOptions:\n");
    for (i = 0; options[i].name; i++)
        printf("\t-%c, --%s\n\t\t\t%s\n",
                options[i].val, options[i].name,
                options_descriptions[i]);
    printf("Version:\n\t%s\n", VERSION_STR);
    printf("Note:\n\t%s\n\n", USAGE_NOTE);
    fflush(stdout);
}

/* show batch information */
static void show_batch_info(bool accel_en, bool gyro_en, unsigned long accel_hz, unsigned long gyro_hz, unsigned long batch_ms)
{
    int64_t curr_ts = get_current_timestamp();
    int64_t odr_ns;
    unsigned long odr_hz = 4;

    if (accel_en && accel_hz > odr_hz)
        odr_hz = accel_hz;
    if (gyro_en && gyro_hz > odr_hz)
        odr_hz = gyro_hz;

    odr_ns = NS_IN_SEC / odr_hz;

    if (batch_ms) {
        if (curr_ts > (last_poll_time_ns + odr_ns)) {
            if (accel_en) {
                if (batched_sample_accel_nb)
                    printf("INFO Previous batch count for Accel is %d\n",
                            batched_sample_accel_nb);
                batched_sample_accel_nb = 0;
            }
            if (gyro_en) {
                if (batched_sample_gyro_nb)
                    printf("INFO Previous batch count for Gyro  is %d\n",
                            batched_sample_gyro_nb);
                batched_sample_gyro_nb = 0;
            }
            printf("INFO New batch duration %" PRId64 " ms\n",
                    (curr_ts - last_poll_time_ns) / 1000000);
        }
    }
    last_poll_time_ns = curr_ts;
    fflush(stdout);
}

/* read sensor data from char device */
static int read_and_show_data(int *accel_orient, int *gyro_orient, double accel_scale, double gyro_scale, bool convert)
{
    unsigned short header;
    char *rdata;
    int sensor, len;
    int nbytes;
    int ptr = 0;
    int gyro[3], accel[3];
    int body_lsb[3];
    double body_conv[3];
    int64_t  gyro_ts, accel_ts;
    bool accel_valid = false;
    bool gyro_valid = false;
    int left_over = 0;
    int64_t curr_ts;
    float ts_gap, ts_gap_prev;

    curr_ts = get_current_timestamp();

    /* read data from char device */
    nbytes = sizeof(iio_read_buf) - iio_read_size;
    len = read(iio_fd, &iio_read_buf[iio_read_size], nbytes);
    //printf("read len = %d\n", len);
    if (len < 0) {
        printf("failed to read iio buffer\n");
        return len;
    }
    if (len == 0) {
        printf("no data in buffer\n");
        return 0;
    }

    iio_read_size += len;

    /* parse data */
    while (ptr < iio_read_size) {
        accel_valid = false;
        gyro_valid = false;
        rdata = &iio_read_buf[ptr];
        header = *(unsigned short*)rdata;

        switch (header) {
            case END_MARKER:
                if ((iio_read_size - ptr) < END_MARKER_SZ) {
                    left_over = iio_read_size - ptr;
                    break;
                }
                sensor = *((int *) (rdata + 4));
                printf("HAL:MARKER DETECTED what:%d\n", sensor);
                ptr += END_MARKER_SZ;
                break;
            case EMPTY_MARKER:
                if ((iio_read_size - ptr) < EMPTY_MARKER_SZ) {
                    left_over = iio_read_size - ptr;
                    break;
                }
                sensor = *((int *) (rdata + 4));
                printf("HAL:EMPTY MARKER DETECTED what:%d\n", sensor);
                ptr += EMPTY_MARKER_SZ;
                break;
            case GYRO_HDR:
                if ((iio_read_size - ptr) < GYRO_DATA_SZ) {
                    left_over = iio_read_size - ptr;
                    break;
                }
                gyro[0] = *((int *) (rdata + 4));
                gyro[1] = *((int *) (rdata + 8));
                gyro[2] = *((int *) (rdata + 12));
                gyro_ts = *((int64_t*) (rdata + 16));
                gyro_valid = true;
                ptr += GYRO_DATA_SZ;
                break;
            case ACCEL_HDR:
                if ((iio_read_size - ptr) < ACCEL_DATA_SZ) {
                    left_over = iio_read_size - ptr;
                    break;
                }
                accel[0] = *((int *) (rdata + 4));
                accel[1] = *((int *) (rdata + 8));
                accel[2] = *((int *) (rdata + 12));
                accel_ts = *((int64_t*) (rdata + 16));
                accel_valid = true;
                ptr += ACCEL_DATA_SZ;
                break;
            default:
                ptr++;
                break;
        }

        /* show data */
        if (accel_valid) {
            ts_gap = (float)(curr_ts - accel_ts)/1000000.f;
            ts_gap_prev = (float)(accel_ts - accel_prev_ts)/1000000.f;
            accel_prev_ts = accel_ts;
            body_lsb[0] = accel[0] * accel_orient[0] + accel[1] * accel_orient[1] + accel[2] * accel_orient[2];
            body_lsb[1] = accel[0] * accel_orient[3] + accel[1] * accel_orient[4] + accel[2] * accel_orient[5];
            body_lsb[2] = accel[0] * accel_orient[6] + accel[1] * accel_orient[7] + accel[2] * accel_orient[8];
            if (convert) {
                body_conv[0] = (double)body_lsb[0] * accel_scale;
                body_conv[1] = (double)body_lsb[1] * accel_scale;
                body_conv[2] = (double)body_lsb[2] * accel_scale;
                printf("Accel body (m/s^2), %+13f, %+13f, %+13f, %20" PRId64 ", %8.3f, %8.3f\n",
                        body_conv[0], body_conv[1], body_conv[2],
                        accel_ts, ts_gap_prev, ts_gap);
            } else {
                printf("Accel body (LSB)  , %+6d, %+6d, %+6d, %20" PRId64 ", %8.3f, %8.3f\n",
                        body_lsb[0], body_lsb[1], body_lsb[2],
                        accel_ts, ts_gap_prev, ts_gap);
            }
            batched_sample_accel_nb++;
        }
        if (gyro_valid) {
            ts_gap = (float)(curr_ts - gyro_ts)/1000000.f;
            ts_gap_prev = (float)(gyro_ts - gyro_prev_ts)/1000000.f;
            gyro_prev_ts = gyro_ts;
            body_lsb[0] = gyro[0] * gyro_orient[0] + gyro[1] * gyro_orient[1] + gyro[2] * gyro_orient[2];
            body_lsb[1] = gyro[0] * gyro_orient[3] + gyro[1] * gyro_orient[4] + gyro[2] * gyro_orient[5];
            body_lsb[2] = gyro[0] * gyro_orient[6] + gyro[1] * gyro_orient[7] + gyro[2] * gyro_orient[8];
            if (convert) {
                body_conv[0] = (double)body_lsb[0] * gyro_scale;
                body_conv[1] = (double)body_lsb[1] * gyro_scale;
                body_conv[2] = (double)body_lsb[2] * gyro_scale;
                printf("Gyro  body (rad/s), %+13f, %+13f, %+13f, %20" PRId64 ", %8.3f, %8.3f\n",
                        body_conv[0], body_conv[1], body_conv[2],
                        gyro_ts, ts_gap_prev, ts_gap);
            } else {
                printf("Gyro  body (LSB)  , %+6d, %+6d, %+6d, %20" PRId64 ", %8.3f, %8.3f\n",
                        body_lsb[0], body_lsb[1], body_lsb[2],
                        gyro_ts, ts_gap_prev, ts_gap);
            }
            batched_sample_gyro_nb++;
        }
        if (left_over) {
            break;
        }
    }

    if (left_over > 0) {
        memmove(iio_read_buf, &iio_read_buf[ptr], left_over);
        iio_read_size = left_over;
    } else {
        iio_read_size = 0;
    }
    fflush(stdout);

    return 0;
}

/* signal handler to disable sensors when ctr-C */
static void sig_handler(int s)
{
    int ret = 0;

    (void)s;

    /* disable all sensors */
    printf("Disable accel\n");
    ret = enable_sensor(SENSOR_ACCEL, 0);
    if (ret) {
        printf("failed to enable accel\n");
        fflush(stdout);
        return;
    }
    printf("Disable gyro\n");
    ret = enable_sensor(SENSOR_GYRO, 0);
    if (ret) {
        printf("failed to enable gyro\n");
        fflush(stdout);
        return;
    }

    printf("Disable buffer\n");
    ret = write_sysfs_int(SYSFS_CHIP_ENABLE, 0);
    if (ret) {
        printf("failed to disable buffer\n");
        fflush(stdout);
        return;
    }

    /* close */
    if (iio_fd != -1) {
        close(iio_fd);
        iio_fd = -1;
    }

    fflush(stdout);
    exit(1);
}


/* --- main --- */
int main(int argc, char *argv[])
{
    int ret;
    int gyro_orient[9], accel_orient[9];
    struct sigaction sig_action;
    int opt, option_index;
    bool accel_en = false;
    bool gyro_en = false;
    unsigned long accel_hz = 5;
    unsigned long gyro_hz = 5;
    unsigned long device_no = 0;
    bool convert = false;
    unsigned long batch_ms = 0;
    int accel_fsr_gee;
    int gyro_fsr_dps;
    double accel_scale = 0;
    double gyro_scale = 0;

    int accel_fsr = DEFAULT_ACCEL_FSR;
    int gyro_fsr = DEFAULT_GYRO_FSR;

    /* Force FSR settings for FIFO high res chips */
#ifdef FIFO_HIGH_RES_ENABLE

#ifdef ACCEL_ENHANCED_FSR_SUPPORT
    accel_fsr = ACCEL_FSR_32G;
#else
    accel_fsr = ACCEL_FSR_16G;
#endif

#ifdef GYRO_ENHANCED_FSR_SUPPORT
    gyro_fsr = GYRO_FSR_4000DPS;
#else
    gyro_fsr = GYRO_FSR_2000DPS;
#endif

#endif

    while ((opt = getopt_long(argc, argv, "hd:a:g:cb:", options, &option_index)) != -1) {
        switch (opt) {
            case 'a':
                accel_en = true;
                accel_hz = strtoul(optarg, NULL, 10);
                break;
            case 'g':
                gyro_en = true;
                gyro_hz = strtoul(optarg, NULL, 10);
                break;
            case 'd':
                device_no = strtoul(optarg, NULL, 10);
                break;
            case 'c':
                convert = true;
                break;
            case 'b':
                batch_ms = (int)strtoul(optarg, NULL, 10);
                break;
            case 'h':
                usage();
                return 0;
        }
    }
    if (!accel_en && !gyro_en) {
        usage();
        return 0;
    }

    /* signal handling */
    sig_action.sa_handler = sig_handler;
    sigemptyset(&sig_action.sa_mask);
    sig_action.sa_flags = 0;
    sigaction(SIGINT, &sig_action, NULL);

    /* set iio sysfs and device paths */
    ret = snprintf(iio_sysfs_path, sizeof(iio_sysfs_path), SYSFS_PATH, device_no);
    if (ret < 0 || ret >= (int)sizeof(iio_sysfs_path)) {
        printf("error %d cannot set iio sysfs path\n", ret);
        fflush(stdout);
        return -errno;
    }
    ret = snprintf(iio_dev_path, sizeof(iio_dev_path), IIO_DEVICE, device_no);
    if (ret < 0 || ret >= (int)sizeof(iio_dev_path)) {
        printf("error %d cannot set iio dev path\n", ret);
        fflush(stdout);
        return -errno;
    }

    printf(">Start\n");
    fflush(stdout);

    /* show chip name */
    ret = show_chip_name();
    if (ret) {
        return ret;
    }

    /* get sensor orientation */
    printf(">Get accel orientation\n");
    fflush(stdout);
    ret = get_sensor_orient(SENSOR_ACCEL, accel_orient);
    if (ret) {
        printf("failed to get accel orientation\n");
        fflush(stdout);
        return ret;
    }
    printf(">Get gyro orientation\n");
    fflush(stdout);
    ret = get_sensor_orient(SENSOR_GYRO, gyro_orient);
    if (ret) {
        printf("failed to get gyro orientation\n");
        fflush(stdout);
        return ret;
    }

    /* setup iio */
    printf(">Set up IIO\n");
    fflush(stdout);
    ret = setup_iio();
    if (ret) {
        printf("failed to set up iio\n");
        fflush(stdout);
        return ret;
    }

    /* make sure all sensors are disabled */
    printf(">Disable accel\n");
    fflush(stdout);
    ret = enable_sensor(SENSOR_ACCEL, 0);
    if (ret) {
        printf("failed to enable accel\n");
        fflush(stdout);
        return ret;
    }
    printf(">Disable gyro\n");
    fflush(stdout);
    ret = enable_sensor(SENSOR_GYRO, 0);
    if (ret) {
        printf("failed to enable gyro\n");
        fflush(stdout);
        return ret;
    }

    /* set batch mode */
    if (accel_en || gyro_en) {
        printf(">Set batch timeout\n");
        fflush(stdout);
        ret = set_sensor_batch_timeout(batch_ms);
        if (ret)
            return ret;
    }

    /* set FIFO high resolution mode */
#ifdef FIFO_HIGH_RES_ENABLE
    printf(">Enable FIFO High resolution mode\n");
    write_sysfs_int(SYSFS_HIGH_RES_MODE, 1); // do not check error
#else
    printf(">Disable FIFO High resolution mode\n");
    write_sysfs_int(SYSFS_HIGH_RES_MODE, 0); // do not check error
#endif
    fflush(stdout);

    /* accel setup */
    if (accel_en) {
        printf(">Set accel FSR\n");
        fflush(stdout);
        ret = set_sensor_fsr(SENSOR_ACCEL, accel_fsr);
        if (ret)
            return ret;
        printf(">Get accel FSR\n");
        fflush(stdout);
        ret = get_sensor_fsr(SENSOR_ACCEL, &accel_fsr_gee);
        if (ret)
            return ret;
        printf(">Set accel rate\n");
        fflush(stdout);
        ret = set_sensor_rate(SENSOR_ACCEL, accel_hz);
        if (ret)
            return ret;
        printf(">Enable accel\n");
        fflush(stdout);
        ret = enable_sensor(SENSOR_ACCEL, 1);
        if (ret) {
            printf("failed to enable accel\n");
            fflush(stdout);
            return ret;
        }
        accel_prev_ts = get_current_timestamp();
        batched_sample_accel_nb = 0;
    }
#ifdef FIFO_HIGH_RES_ENABLE
    accel_scale = (double)accel_fsr_gee / 524288.f * 9.80665f; // LSB(20bit) to m/s^2
#else
    accel_scale = (double)accel_fsr_gee / 32768.f * 9.80665f; // LSB(16bit) to m/s^2
#endif

    /* gyro setup */
    if (gyro_en) {
        printf(">Set gyro FSR\n");
        fflush(stdout);
        ret = set_sensor_fsr(SENSOR_GYRO, gyro_fsr);
        if (ret)
            return ret;
        printf(">Get gyro FSR\n");
        fflush(stdout);
        ret = get_sensor_fsr(SENSOR_GYRO, &gyro_fsr_dps);
        if (ret)
            return ret;
        printf(">Set gyro rate\n");
        fflush(stdout);
        ret = set_sensor_rate(SENSOR_GYRO, gyro_hz);
        if (ret)
            return ret;
        printf(">Enable gyro\n");
        fflush(stdout);
        ret = enable_sensor(SENSOR_GYRO, 1);
        if (ret) {
            printf("failed to enable gyro\n");
            fflush(stdout);
            return ret;
        }
        gyro_prev_ts = get_current_timestamp();
        batched_sample_gyro_nb = 0;
    }
#ifdef FIFO_HIGH_RES_ENABLE
    gyro_scale = (double)gyro_fsr_dps / 524288.f * M_PI / 180; // LSB(20bit) to rad/s
#else
    gyro_scale = (double)gyro_fsr_dps / 32768.f * M_PI / 180; // LSB(16bit) to rad/s
#endif

    last_poll_time_ns = get_current_timestamp();

    /* collect sensor data */
    while (1) {
        struct pollfd fds[1];
        int nb;
        fds[0].fd = iio_fd;
        fds[0].events = POLLIN;
        fds[0].revents = 0;
        nb = poll(fds, 1, -1);
        if (nb > 0) {
            if (fds[0].revents & (POLLIN | POLLPRI)) {
                fds[0].revents = 0;
                /* show batch information */
                show_batch_info(accel_en, gyro_en, accel_hz, gyro_hz, batch_ms);
                /* read sensor from FIFO and show */
                read_and_show_data(accel_orient, gyro_orient, accel_scale, gyro_scale, convert);
            }
        }
    }
    return 0;
}

