import serial
import os
from PIL import Image
import struct
import numpy as np

# Define the serial port and parameters
ser = serial.Serial(
    port='COM19',  # Change this to your serial port
    baudrate=115200,
    bytesize=serial.EIGHTBITS,
    parity=serial.PARITY_NONE,
    stopbits=serial.STOPBITS_ONE
)

# Folder path where images are stored
folder_path = 'C:\\Projetos\\T1BA6\\arduino-camera\\images'  # Update with your folder path

def load_most_recent_image():
    """Load the most recent image from the folder."""
    files = [f for f in os.listdir(folder_path) if f.lower().endswith(('.png', '.jpg', '.bmp'))]
    files.sort(key=lambda f: os.path.getmtime(os.path.join(folder_path, f)), reverse=True)
    
    if files:
        most_recent_image_path = os.path.join(folder_path, files.pop(0))
        print(f"Loading image: {most_recent_image_path}")
        image = Image.open(most_recent_image_path).convert("RGB")
        return image
    else:
        print("No images found in the folder!")
        return None

def rgb_to_rgb565(r, g, b):
    """Convert RGB to RGB565 format (RRRRRGGG GGGBBBBB)."""
    r = r >> 3
    g = g >> 2
    b = b >> 3
    return (r << 11) | (g << 5) | b

def transmit_image_in_rgb565(image):
    """Transmit the image via serial in RGB565 format."""
    width, height = image.size
    pixels = image.load()

    for y in range(height):
        for x in range(width):
            r, g, b = pixels[x, y]
            rgb565 = rgb_to_rgb565(r, g, b)
            ser.write(struct.pack(">H", rgb565))

    print("Image transmitted in RGB565 format.")

def receive_transmissions():
    """Receive 54 transmissions and store them in a 3x3x6 array."""
    cube_array = np.zeros((3, 3, 6), dtype=int)
    for face in range(6):
        for row in range(3):
            for col in range(3):
                data = ser.read(1)
                cube_array[row, col, face] = int.from_bytes(data, byteorder='big')
                print(f"Received data: Face {face+1}, Row {row+1}, Col {col+1}: {cube_array[row, col, face]}")
    return cube_array

# Main program loop
cube_faces = []
while len(cube_faces) < 6:
    data = ser.read(1)
    if data == b'\xFF':  # Check if received data matches 11111111
        image = load_most_recent_image()
        if image:
            cube_faces.append(image)
            print(f"Stored image {len(cube_faces)}")
            transmit_image_in_rgb565(image)
        else:
            print("No image found, retrying...")

print("All 6 faces of the cube have been stored.")

# Receive and store 54 transmissions in a 3x3x6 array
cube_data = receive_transmissions()
print("Cube data received successfully.")

# Combine all the data into the movements array and transmit
movements = {
    "images": cube_faces,
    "cube_data": cube_data.tolist()
}

# Example movements array
movements = [2, 4, 1, 1, 5, 0]

# Transmit each movement value over the serial port
for movement in movements:
    ser.write(bytes([movement]))  # Convert the integer to a single byte and send
    print(f"Transmitted movement: {movement}")


# Close the serial port
ser.close()
