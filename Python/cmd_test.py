import argparse

# Create the argument parser
parser = argparse.ArgumentParser(description="Serial communication argument parser")

# Add arguments for COM port, baud rate, and sample size
parser.add_argument("com_port", help="The COM port for the serial connection (e.g., COM3, /dev/ttyUSB0)")
parser.add_argument("baud_rate", type=int, help="The baud rate for the serial connection (e.g., 9600, 115200)")
parser.add_argument("sample_size", type=int, help="The number of samples to read")

# Parse the arguments
args = parser.parse_args()

# Access the arguments
com_port = args.com_port
baud_rate = args.baud_rate
sample_size = args.sample_size

# Display the input values
print(f"COM Port: {com_port}")
print(f"Baud Rate: {baud_rate}")
print(f"Sample Size: {sample_size}")

# The rest of your serial communication code can go here
# For example, you could use the 'pyserial' library to open the COM port and read data
