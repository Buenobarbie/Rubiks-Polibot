import serial
import os
from PIL import Image
import struct
import numpy as np

import cv2
import numpy as np

from image_processing import identificar_cor, matriz_de_cores, path_to_most_recent_image, delete_all_images
from solver import steps_to_rubiks_polibot_movements

# ------------------------------ DEFINIR CONEXÃO SERIAL ------------------------------
ser = serial.Serial(
    port='COM9',  # Change this to your serial port
    baudrate=115200,
    bytesize=serial.EIGHTBITS,
    parity=serial.PARITY_NONE,
    stopbits=serial.STOPBITS_ONE
)
print("Porta Serial conectada\n")

# ------------------------------ PASTA DAS IMAGENS DO CUBO ------------------------------
folder_path = 'C:\\Projetos\\T1BA6\\imagens'  


# ------------------------------ CAPTURA IMAGEM DE CADA FACE (6) ------------------------------
cube_faces = []
while len(cube_faces) < 6:

    print("Esperando comando para capturar imagem...")
    data = ser.read(1)
    data_int = int.from_bytes(data, byteorder='big')
    data_bin = "{:08b}".format(data_int)
    print(f"Received data: {data_int} (binary: {data_bin})")

    # Se receber um byte 0xFF, capturar a imagem
    if data == b'\xFF':  
        image = path_to_most_recent_image(folder_path)
        if image:
            face = matriz_de_cores(image)
            print(face)
            cube_faces.append(face)
            print(f"Imagem {len(cube_faces)} armazenada")
            delete_all_images(folder_path)
        else:
            print("Nennuma imagem encontrada")

# -----------------------------  ROTACIONA IMAGENS SE NECESSÁRIO ------------------------------
cube = []
face_letters = ['R', 'B', 'L', 'F', 'D', 'U']
face_colors = []
for i in range(1,7):
    colors = cube_faces[i-1]
    colors = rotated_180 = np.array(colors)[::-1, ::-1].tolist() 
    
    face_colors.append(colors[1][1])

    if i == 5 or i == 6:
        colors = np.array(colors)[::-1].T.tolist()

    cube.append(colors)

# ------------------------- STRING DO ESTADO DO CUBO -------------------------
cube_String = ""
for l in ['U', 'R', 'F', 'D', 'L', 'B']:
    print(cube[face_letters.index(l)])
    for i in range(3):
        for j in range(3):
            color = cube[face_letters.index(l)][i][j]
            letter = face_letters[face_colors.index(color)]
            cube_String += letter
print(cube_String)

# ------------------------- RESOLUÇÃO DO CUBO  POR KOCIEMBA -------------------------
import kociemba
steps = kociemba.solve(cube_String)
print(steps)


# ------------------------- MOVIMENTOS PARA O POLIBOT -------------------------
# Example movements array
# movements = [1, 1, 2, 6, 2, 1, 1, 5, 1, 1, 1, 2, 6, 2, 5, 1, 6, 1, 1, 2, 5, 2, 1, 1, 1, 6, 1, 1, 1, 2, 5, 2, 0]
# movements = [1, 2, 6, 2, 1, 2, 5, 2 ,0]
# movements = [0]
# movements = [2,6,2,1,2,4,2,1,1,0]
movements = steps_to_rubiks_polibot_movements(steps)

# ------------------------- TRANSMISSÃO DOS MOVIMENTOS -------------------------
print("Esperando para transmitir movimentos")
data = ser.read(1)
if data == b'\xFF':
    print("Começando transmissao dos movimentos")
    for movement in movements:
        ser.write(bytes([movement])) 
        print(f"Movimento transmitido: {movement}")

# ------------------------- LIMPEZA DE IMAGENS -------------------------
while True:
    delete_all_images(folder_path)

# Close the serial port
ser.close()