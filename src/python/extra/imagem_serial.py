import serial
import os
import time
from PIL import Image
import struct

# Define the serial port and parameters
ser = serial.Serial(
    port='COM19',  # Change this to your serial port
    baudrate=115200,
    bytesize=serial.EIGHTBITS,      # 8 data bits
    parity=serial.PARITY_NONE,      # No parity bit
    stopbits=serial.STOPBITS_ONE    # 1 stop bit
)

# Folder path where images are stored
folder_path = 'C:\\Projetos\\T1BA6\\arduino-camera\\images'  # Update with your folder path

def delete_all_images(folder_path):
    """Delete all image files in the folder."""
    for filename in os.listdir(folder_path):
        file_path = os.path.join(folder_path, filename)
        if os.path.isfile(file_path):
            os.remove(file_path)
            print(f"Deleted image: {filename}")

def load_most_recent_image():
    """Load the most recent image from the folder."""
    # Get all image files (e.g., PNG, JPG)
    files = [f for f in os.listdir(folder_path) if f.lower().endswith(('.png', '.jpg', '.bmp'))]
    
    # Sort files by modification time, most recent first
    files.sort(key=lambda f: os.path.getmtime(os.path.join(folder_path, f)), reverse=True)
    
    if files:
        most_recent_image_path = os.path.join(folder_path, files[0])
        print(f"Loading most recent image: {most_recent_image_path}")
        image = Image.open(most_recent_image_path)
        return image.convert("RGB")
    else:
        print("No images found in the folder!")
        return None

def rgb_to_rgb565(r, g, b):
    """Convert RGB to RGB565 format (RRRRRGGG GGGBBBBB)."""
    r = r >> 3  # Scale 8-bit red (0-255) to 5-bit (0-31)
    g = g >> 2  # Scale 8-bit green (0-255) to 6-bit (0-63)
    b = b >> 3  # Scale 8-bit blue (0-255) to 5-bit (0-31)
    
    return (r << 11) | (g << 5) | b

def transmit_image_in_rgb565(image):
    """Transmit the image via serial in RGB565 format."""
    width, height = image.size
    print(width,height)
    pixels = image.load()

    # Go through each pixel of the image and convert to RGB565
    for y in range(height):
        for x in range(width):
            r, g, b = pixels[x, y]
            rgb565 = rgb_to_rgb565(r, g, b)

            # Send each RGB565 value as a 2-byte integer
            ser.write(struct.pack(">H", rgb565))  # >H means "big-endian unsigned short (2 bytes)"

            # # Optional: Add a small delay to avoid overloading the serial port
            # time.sleep(0.01)

    print("Image transmitted in RGB565 format.")
image = []
# Main program loop
while True:
    # Wait for a serial signal of '11111111' (binary)
    data = ser.read(1)  # Read 1 byte from the serial port
    data_int = int.from_bytes(data, byteorder='big')
    data_bin = "{:08b}".format(data_int)
    print(f"Received data: {data_int} (binary: {data_bin})")

    if data_bin == "11111111":    
        # Load the most recent image from the folder
        image = load_most_recent_image()
        # delete_all_images()
        hex_value = bytes([0xFF])  # Create a byte object with value 0x0A
        ser.write(hex_value)       # Send the data over the serial port
    
    if image:
        # Transmit the image in RGB565 format
        transmit_image_in_rgb565(image)
        image = []
        exit(1)
    else:
        print("No image found")

    hex_value = bytes([0xFF])  # Create a byte object with value 0x0A
    ser.write(hex_value)       # Send the data over the serial port


# Close the serial port
ser.close()