/*
 * ADAU1978.c
 *
 *  Created on: Oct 10, 2024
 *      Author: malef
 */


#include "ADAU1978.h"
extern I2C_HandleTypeDef hi2c1;
static uint8_t gain_code(float gain);
HAL_StatusTypeDef Audio_ADC_Init(ADAU1978_t* pHandle){
	unsigned char buf[11];
	buf[0] = 0x51;
	HAL_StatusTypeDef xStatus;
	xStatus = HAL_I2C_Mem_Write(&hi2c1, ADAU1978_ADDR<<1, PLL_CONTROL_REG, 1, buf,1, 1000);
	if (xStatus != HAL_OK){
		return xStatus;
	}
	HAL_Delay(100);

	// config others
	buf[0] = pHandle->block_power_sai;
	buf[1] = pHandle->sai_ctrl0;
	buf[2] = pHandle->sai_ctrl1;
	buf[3] = pHandle->sai_cmap12;
	buf[4] = pHandle->sai_cmap34;
	buf[5] = pHandle->sai_overtemp;

	// get gain code
	uint8_t gain_bin = gain_code(pHandle->gain_db);
	for (int i = 6; i < 10; i++){
		buf[i] = gain_bin;
	}
	buf[10] = pHandle->misc_control;
	xStatus = HAL_I2C_Mem_Write(&hi2c1, ADAU1978_ADDR<<1,BLOCK_POWER_SAI_REG, 1, buf,11, 1000);
	if (xStatus != HAL_OK){
		return xStatus;
	}
	HAL_Delay(100);

	// DC calibration and HPF
	buf[0] = pHandle->dc_hpf_cal;

	return HAL_I2C_Mem_Write(&hi2c1, ADAU1978_ADDR<<1, DC_HPF_CAL_REG, 1, buf, 1, 1000);


}
uint8_t isPll_locked(){
	uint8_t reg_value = 0;

	// Master POWER UP
	if (HAL_I2C_Mem_Read(&hi2c1, ADAU1978_ADDR<<1, PLL_CONTROL_REG, 1, &reg_value, 1, 1000)){
		return 0;
	}
	if (reg_value>>7){
		return 1;
	}
	return 0;
}
uint8_t  getCliipped(){
	uint8_t reg_value = 0;

		// Master POWER UP
	HAL_I2C_Mem_Read(&hi2c1, ADAU1978_ADDR<<1, ASDC_CLIP_REG, 1, &reg_value, 1, 1000);

	return reg_value;

}
void Audio_ADC_StructInit(ADAU1978_t* pHandle){
	// power off all adcs
	pHandle->block_power_sai = 0x30;
	pHandle->sai_ctrl0       = 0x02;
	pHandle->sai_ctrl1       = 0x00;
	pHandle->sai_cmap12      = SAI_CMAP12_RST_VAL;
	pHandle->sai_cmap34      = SAI_CMAP34_RST_VAL;
	pHandle->sai_overtemp    = 0x00;
	pHandle->dc_hpf_cal      = 0x00;
	pHandle->misc_control    = MISC_CONTROL_RST_VAL;
	pHandle->gain_db         = 0;
}
static uint8_t gain_code(float gain){
	if ((gain > MAX_GAIN) || (gain< MIN_GAIN)){
		return 0xA0; // 0 dB GAIN
	}
	return (MAX_GAIN-gain)/GAIN_STEP;
}

HAL_StatusTypeDef Audio_ADC_Calibrate(){
	uint8_t reg_value = DC_CALIB_EN;
	if (Audio_ADC_PowerOn() != HAL_OK){
		return HAL_ERROR;
	}
	HAL_Delay(100);
	if (HAL_I2C_Mem_Write(&hi2c1, ADAU1978_ADDR<<1, MISC_CONTROL_REG, 1, &reg_value,1, 1000)!= HAL_OK){
		return HAL_ERROR;

	}
	HAL_Delay(500);
	reg_value = MISC_CONTROL_RST_VAL;
	return HAL_I2C_Mem_Write(&hi2c1, ADAU1978_ADDR<<1, MISC_CONTROL_REG, 1, &reg_value,1, 1000);

}

HAL_StatusTypeDef Audio_ADC_PowerOn(){
	uint8_t reg_value = 0x01;
	return HAL_I2C_Mem_Write(&hi2c1, ADAU1978_ADDR<<1, M_POWER_REG, 1, &reg_value,1, 1000);


}
