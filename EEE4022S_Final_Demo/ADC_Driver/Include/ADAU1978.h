/*
 * ADAU1978.h
 *
 *  Created on: Oct 10, 2024
 *      Author: Malefetsane Lenka
 */
#include "main.h"
#ifndef ADAU1978_H_
#define ADAU1978_H_

// I2C Address
#define  ADAU1978_ADDR 0x71

//------------------------------------------
// Registers
//------------------------------------------


#define M_POWER_REG                       (unsigned char)(0x00)
#define PLL_CONTROL_REG                   (unsigned char)(0x01)
#define BLOCK_POWER_SAI_REG               (unsigned char)(0x04)
#define SAI_CTRL0_REG                     (unsigned char)(0x05)
#define SAI_CTRL1_REG                     (unsigned char)(0x06)
#define SAI_CMAP12_REG                    (unsigned char)(0x07)
#define SAI_CMAP34_REG                    (unsigned char)(0x08)
#define SAI_OVERTEMP_REG                  (unsigned char)(0x09)
#define POSTADC_GAIN1_REG                 (unsigned char)(0x0A)
#define POSTADC_GAIN2_REG                 (unsigned char)(0x0B)
#define POSTADC_GAIN3_REG                 (unsigned char)(0x0C)
#define POSTADC_GAIN4_REG                 (unsigned char)(0x0D)
#define MISC_CONTROL_REG                  (unsigned char)(0x0E)
#define ASDC_CLIP_REG                     (unsigned char)(0x19)
#define DC_HPF_CAL_REG                    (unsigned char)(0x1A)

// registers RESET VALUES
#define SAI_CMAP12_RST_VAL                (unsigned char)(0x10)
#define SAI_CMAP34_RST_VAL                (unsigned char)(0x32)
#define MISC_CONTROL_RST_VAL              (unsigned char)(0x02)

#define MAX_GAIN                           (float)(60)
#define MIN_GAIN                           (float)(-35.625)
#define GAIN_STEP                          (float)(0.375)

// ADC power EN
#define ADC_EN1                            (unsigned char)(0x31)
#define ADC_EN2                            (unsigned char)(0x32)
#define ADC_EN3                            (unsigned char)(0x34)
#define ADC_EN4                            (unsigned char)(0x38)
#define ADC_ENALL                          (unsigned char)(0x3F)

// drive enable
#define SAI_DRV_C1                         (unsigned char)(1<<4)
#define SAI_DRV_C2                         (unsigned char)(1<<5)
#define SAI_DRV_C3                         (unsigned char)(1<<6)
#define SAI_DRV_C4                         (unsigned char)(1<<7)
#define SAI_DRV_ALL                        (unsigned char) (0xF0)
//  CTRL0
// SAI Format
#define SAI_CTRL0_STREREO                        (unsigned char)(0x02)
#define SAI_CTRL0_TDM2                           (unsigned char)(0x0A)
#define SAI_CTRL0_TDM4                           (unsigned char)(0x12)
// Data Format
#define SAI_CTRL0_SDATA_FMT_I2S                  (unsigned char)(0x00<<6)
#define SAI_CTRL0_SDATA_FMT_LJ                   (unsigned char)(0x01<<6)
#define SAI_CTRL0_SDATA_FMT_RJ_24                (unsigned char)(0x02<<6)
#define SAI_CTRL0_SDATA_FMT_RJ_16                (unsigned char)(0x03<<6)

// CTRL1
#define SAI_CTRL1_DW_24_BITS             (unsigned char)(0<<4)
#define SAI_CTRL1_DW_16_BITS             (unsigned char)(1<<4)

#define SAI_CTRL1_LR_MODE_PULSE          (unsigned char)(1<<3)

// slot width
#define SAI_CTRL1_SW_32_BCKS             (unsigned char)(0x00<<5)
#define SAI_CTRL1_SW_24_BCKS             (unsigned char)(0x01<<5)
#define SAI_CTRL1_SW_16_BCKS             (unsigned char)(0x02<<5)

// Calibration
#define DC_CALIB_EN                       (unsigned char)(0x03)

// Filter and DC calib subtraction
// HPF EN
#define DC_HPF_C1                        (unsigned char)(1<<0)
#define DC_HPF_C2                        (unsigned char)(1<<1)
#define DC_HPF_C3                        (unsigned char)(1<<2)
#define DC_HPF_C4                        (unsigned char)(1<<3)
#define DC_HPF_ALL                       (unsigned char)(0xF)
// DC SUB EN
#define DC_SUB_C1                        (unsigned char)(1<<4)
#define DC_SUB_C2                        (unsigned char)(1<<5)
#define DC_SUB_C3                        (unsigned char)(1<<6)
#define DC_SUB_C4                        (unsigned char)(1<<7)
#define DC_SUB_ALL                       (unsigned char)(0xF0)


typedef struct {
	unsigned char block_power_sai;
	unsigned char sai_ctrl0;
	unsigned char sai_ctrl1;
	unsigned char sai_cmap12;
	unsigned char sai_cmap34;
	unsigned char sai_overtemp;
	unsigned char misc_control;
	unsigned char dc_hpf_cal;
	float gain_db;

}ADAU1978_t;
HAL_StatusTypeDef Audio_ADC_Init(ADAU1978_t* pHandle);
void Audio_ADC_StructInit(ADAU1978_t* pHandle);
HAL_StatusTypeDef Audio_ADC_Calibrate();
HAL_StatusTypeDef Audio_ADC_PowerOn();
uint8_t isPll_locked();
uint8_t  getCliipped();
#endif /* ADAU1978_H_ */
