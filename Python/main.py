import serial
import time
import argparse

def serial_port_init(port, baud_rate, time_out):
    # initialise a serial port
    try:
        ser = serial.Serial(port, baud_rate, timeout=time_out) 
        
        time.sleep(2)  # Give some time for the connection to be established

        print(f"Serial port {port} initialized successfully.")
        return ser
    
    except serial.SerialException as e:
        print(f"Serial initialisation error: {e}")
        return None

    except Exception as e:
        print(f"An unexpected error occurred: {e}")
        return None
def read_from_serial(ser, arr_size):
    received_data = bytearray()
    while len(received_data) < arr_size:
        # Read remaining bytes needed
        remaining_bytes = arr_size - len(received_data)
        data = ser.read(remaining_bytes)
        if data:
            received_data.extend(data)
    return received_data
def write_stereo(data_buffer):
    # File handles for each channel
    files = [
        open('left.txt', 'w'),
        open('right.txt', 'w'),
    ]
    for i in range(0, len(data_buffer), 8):
        # Extract 3 bytes for each channel and convert them to 24-bit signed integers
        left  = (data_buffer[i]       | (data_buffer[i + 1]  << 8) | (data_buffer[i + 2]  << 16)) 
        right = (data_buffer[i + 4]   | (data_buffer[i + 5]  << 8) | (data_buffer[i + 6]  << 16))
        if left & 0x800000:
            left -= 0x1000000
        if right & 0x800000:
            right -= 0x1000000
        # Write the values to respective files
        files[0].write(f"{left}\n")
        files[1].write(f"{right}\n")
        # Optional: Flush files to ensure data is written immediately
        for f in files:
            f.flush()
    return None
def write_tdm4(data_buffer):
    # File handles for each channel
    files = [
        open('slot1.txt', 'w'),
        open('slot2.txt', 'w'),
        open('slot3.txt', 'w'),
        open('slot4.txt', 'w'),
    ]
    for i in range(0, len(data_buffer), 16):
        # Extract 3 bytes for each channel and convert them to 24-bit signed integers
        slot1 = (data_buffer[i]          | (data_buffer[i + 1]   << 8) | (data_buffer[i +  2]  << 16)) 
        slot2 = (data_buffer[i +  4]     | (data_buffer[i + 5]   << 8) | (data_buffer[i +  6]  << 16))
        slot3 = (data_buffer[i +  8]     | (data_buffer[i + 9]   << 8) | (data_buffer[i + 10]  << 16)) 
        slot4 = (data_buffer[i + 12]     | (data_buffer[i + 13]  << 8) | (data_buffer[i + 14]  << 16))
        if slot1 & 0x800000:
            slot1 -= 0x1000000
        if slot2 & 0x800000:
            slot2 -= 0x1000000
        if slot3 & 0x800000:
            slot3 -= 0x1000000
        if slot4 & 0x800000:
            slot4 -= 0x1000000
        # Write the values to respective files
        files[0].write(f"{slot1}\n")
        files[1].write(f"{slot2}\n")
        files[2].write(f"{slot3}\n")
        files[3].write(f"{slot4}\n")
        # Optional: Flush files to ensure data is written immediately
        for f in files:
            f.flush()
    return None
def write_sigle(data_buffer):
    output_file = "single.txt"
    # Open the output file in write mode
    with open(output_file, 'w') as file:
        # Process the received data in 2-byte chunks
        for i in range(0, len(data_buffer), 2):
            # MSB is the first byte, LSB is the second byte
            value = data_buffer[i]| (data_buffer[i + 1] << 8)
            # Write the integer value to the file
            file.write(f"{value}\n")
def read_args():
    # Create the argument parser
    parser = argparse.ArgumentParser(description="Serial communication argument parser")
    
  

    # Add arguments for COM port, baud rate, and sample size
    parser.add_argument("com_port", help="The COM port for the serial connection (e.g., COM3, /dev/ttyUSB0)")
    parser.add_argument("baud_rate", type=int, help="The baud rate for the serial connection (e.g., 9600, 115200)")
    parser.add_argument("sample_size", type=int, help="The number of samples to read") 
    
    args = parser.parse_args()    
    
    return (args.com_port, args.baud_rate, args.sample_size) 
def main():
    com_port, baud_rate, sample_size = read_args()
    
    # Display args
    print(f"COM Port: {com_port}")
    print(f"Baud Rate: {baud_rate}")
    print(f"Sample Size: {sample_size}")
    
    # initialise a port
    ser = serial_port_init(com_port, baud_rate, 100)
    if ser:
        print("Starting...............................")

        # acquire adc data
        print("Reading from built-in ADC")
        ser.write("ADC".encode("utf-8"))
        time.sleep(5)
        print("Ready!!!!!")
        buf = read_from_serial(ser, sample_size*2)
        write_sigle(buf)
        print("Done reading MCU ADC")
        
        # acquire pcm1808 data
        print("Reading from PCM1808")
        ser.write("I2S".encode("utf-8"))
        time.sleep(5)
        print("Ready!!!!!")
        buf = read_from_serial(ser, sample_size*8)
        write_stereo(buf)
        print("Done reading PCM1808")
        
        # acquire ADAU1978 data
        print("Reading from ADAU1978")
        ser.write("TDM".encode("utf-8"))
        time.sleep(5)
        print("Ready!!!!!")
        buf = read_from_serial(ser, sample_size*16)
        write_tdm4(buf)
        print("Done reading ADAU1978")
        
        
        print("Done...............................")
if __name__ == "__main__":
    main()