################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../ADC_Driver/Source/ADAU1978.c 

OBJS += \
./ADC_Driver/Source/ADAU1978.o 

C_DEPS += \
./ADC_Driver/Source/ADAU1978.d 


# Each subdirectory must supply rules for building sources it contributes
ADC_Driver/Source/%.o ADC_Driver/Source/%.su ADC_Driver/Source/%.cyclo: ../ADC_Driver/Source/%.c ADC_Driver/Source/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m7 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F767xx -c -I../Core/Inc -I"C:/Users/malef/STM32CubeIDE/workspace_1.16.0/EEE4022S_Final_Demo/ADC_Driver/Include" -I../Drivers/STM32F7xx_HAL_Driver/Inc -I../Drivers/STM32F7xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F7xx/Include -I../Drivers/CMSIS/Include -I../USB_DEVICE/App -I../USB_DEVICE/Target -I../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../Middlewares/ST/STM32_USB_Device_Library/Class/CDC/Inc -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-ADC_Driver-2f-Source

clean-ADC_Driver-2f-Source:
	-$(RM) ./ADC_Driver/Source/ADAU1978.cyclo ./ADC_Driver/Source/ADAU1978.d ./ADC_Driver/Source/ADAU1978.o ./ADC_Driver/Source/ADAU1978.su

.PHONY: clean-ADC_Driver-2f-Source

