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
    port='COM23',  # Change this to your serial port
    baudrate=115200,
    bytesize=serial.EIGHTBITS,
    parity=serial.PARITY_NONE,
    stopbits=serial.STOPBITS_ONE
)
print("Porta Serial conectada\n")

# ------------------------------ PASTA DAS IMAGENS DO CUBO ------------------------------
folder_path = 'C:\\Projetos\\T1BA6\\arduino-camera\\images'  


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
            # delete_all_images(folder_path)
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

    print(colors)
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
# x -> hit once
# y -> hit twice
# z -> hit thrice
# r -> rotate cw 90
# i -> rotate ccw 90
# p -> rotate cw 180
# q -> rotate ccw 180
# 1 -> rotate ccw 90 (blocked)
# 2 -> rotate cw 90 (blocked)
# 3 -> rotate ccw 180 (blocked)
# 4 -> rotate cw 180 (blocked)

moves = [{"R": ["z1x"],"R'": ["yixrxi2x"],"R2":["z3x"],
          "L":["x1z"],"L'":["xi2xixi"],"L2":["x3z"],
          "U":["y1y"],"U'":["yi2yi"],"U2":["y3y"],
          "D":["1"],"D'":["zixrxi2"],"D2":["3"],
          "F":["iz1xr"],"F'":["iz2ixrx"],"F2":["qxrzr3xr","xizi4ixrx"],
          "B":["ix1zr"],"B'":["ix2yixrx"],"B2":["xixi4xi"]},

         {"R": ["z1x"],"R'": ["z2x"],"R2":["rxizi4x","ixrzr3x"],
          "L":["x1z"],"L'":["x2z"],"L2":["ixrxi4z","rxixr3z"],
          "U":["y1y"],"U'":["y2y"],"U2":["xixrxi4y","xrxixr3y"],
          "D":["1"],"D'":["2"],"D2":["xixrzr3","xrxizi4"],
          "F":["rx1zi"],"F'":["iz2xr"],"F2":["rx3yrxix","iz4ixrx"],
          "B":["rz1xi"],"B'":["ix2yixrx"],"B2":["ix4yixrx","rz3rxix"]},

         {"R": ["yrxixr1x"],"R'": ["z2x"],"R2":["z4x"],
          "L":["xr1xrxr"],"L'":["x2z"],"L2":["x4z"],
          "U":["yr1yr"],"U'":["y2y"],"U2":["y4y"],
          "D":["zrxixr1"],"D'":["2"],"D2":["4"],
          "F":["rx1yrxix"],"F'":["rx2zi"],"F2":["xrxr3xr"],
          "B":["rz1rxix"],"B'":["rz2xi"],"B2":["pxizi4xi","xrzr3rxix"]}]

nextState =[{"R": [1],"R'": [0],"R2":[2],
          "L":[1],"L'":[2],"L2":[2],
          "U":[1],"U'":[1],"U2":[2],
          "D":[1],"D'":[0],"D2":[2],
          "F":[1],"F'":[0],"F2":[1,0],
          "B":[1],"B'":[0],"B2":[1]},

         {"R": [2],"R'": [0],"R2":[0,2],
          "L":[2],"L'":[0],"L2":[0,2],
          "U":[2],"U'":[0],"U2":[0,2],
          "D":[2],"D'":[0],"D2":[2,0],
          "F":[2],"F'":[0],"F2":[2,0],
          "B":[2],"B'":[1],"B2":[0,2]},

         {"R": [2],"R'": [1],"R2":[0],
          "L":[0],"L'":[1],"L2":[0],
          "U":[1],"U'":[1],"U2":[0],
          "D":[2],"D'":[1],"D2":[0],
          "F":[2],"F'":[1],"F2":[1],
          "B":[2],"B'":[1],"B2":[1,2]}]

str = steps
sol = str.split()

def cancle(str):
    stack = []
    stack.append("0")
    rot = 0
    for i in str:
        top = stack.pop()
        if(i == "x"):
            if(top == "x"):
                stack.append("y")
                continue
            if(top == "y"):
                stack.append("z")
                continue
            if(top == "z"):
                continue
        if (i == "y"):
            if (top == "x"):
                stack.append("z")
                continue
            if (top == "y"):
                continue
            if (top == "z"):
                stack.append("x")
                continue
        if (i == "z"):
            if (top == "x"):
                continue
            if (top == "y"):
                stack.append("x")
                continue
            if (top == "z"):
                stack.append("y")
                continue
        if (i == "r"):
            if (top == "r"):
                stack.append("p")
                continue
            if (top == "i"):
                continue
            if (top == "q"):
                stack.append("i")
                continue
        if (i == "i"):
            if (top == "r"):
                continue
            if (top == "i"):
                stack.append("q")
                continue
            if (top == "p"):
                stack.append("r")
                continue
        if (i == "p"):
            if (top == "i"):
                stack.append("r")
                continue
            if (top == "q" or top == "p"):
                continue
        if (i == "q"):
            if (top == "r"):
                stack.append("i")
                continue
            if (top == "q" or top == "p"):
                continue
        stack.append(top)
        stack.append(i)
        if(i == "1" or i == "2" or i == "3" or i == "4"):
            rot = rot + 1
            if(rot == len(sol)):
                break
    return stack

def value(stack):
    value = 0
    for i in stack:
        if(i == "r" or i == "i"):
            value = value + 1
        if(i == "p" or i == "q"):
            value = value + 1.5
        if(i == "x"):
            value = value + 2
        if(i == "y"):
            value = value + 3.5
        if(i == "z"):
            value = value + 4.5
    return value

def reduce(i,str,state):
    if(i == len(sol)):
        str = cancle(str)
        return str
    length = 99999
    best = ""
    for j in range(len(moves[state][sol[i]])):
        temp  = reduce(i+1,str+moves[state][sol[i]][j],nextState[state][sol[i]][j])
        val = value(stack = temp)
        if(val < length):
            length = val
            best = temp
    return best

def nMoves(str):
    n = 0
    for i in str:
        n = n + 1
        if(i == "y"):
            n = n + 1
        if(i == "z"):
            n = n + 2
    return n
strReduced = reduce(i = 0,str = "",state = 0)
strReduced = strReduced[1:]
print("".join(strReduced))

# 1: hit
# 2: block
# 3: unblock
# 4: rotate to 0°
# 5: rotate to 90°
# 6: rotate to 180°

def process_signals(signals):
    # Define mappings
    hits = {'x': '1', 'y': '11', 'z': '111'}
    rotations = {
        'r': -90, 'i': 90, 'p': -180, 'q': 180,
        '1': 90, '2': -90, '3': 180, '4': -180
    }
    blocked_rotations = {'1', '2', '3', '4'}
    target_angles = {
    0: '4',    # Rotate to 0°
    90: '5',   # Rotate to 90°
    180: '6',  # Rotate to 180°
    270: '5'   # Rotate to 90° (270° is equivalent to -90°)
}

    
    # Track current position
    current_angle = 0
    result = []
    
    for signal in signals:
        if signal in hits:
            # Add hits to result
            result.append(hits[signal])
        elif signal in rotations:
            # Calculate target angle
            rotation = rotations[signal]
            if signal in blocked_rotations:
                # Blocked rotation
                result.append('2')  # Block
                rotation_command = target_angles[(current_angle + rotation) % 360]
                current_angle = (current_angle + rotation) % 360
                result.append(rotation_command)  # Rotate
                result.append('3')  # Unblock
            else:
                # Unblocked rotation
                current_angle = (current_angle + rotation) % 360
                rotation_command = target_angles[current_angle]
                result.append(rotation_command)
    
    return ''.join(result).replace('3', '2')

# Example usage
signals = strReduced
movements = process_signals(signals) + "0"


# Example movements array
# movements = [1, 1, 2, 6, 2, 1, 1, 5, 1, 1, 1, 2, 6, 2, 5, 1, 6, 1, 1, 2, 5, 2, 1, 1, 1, 6, 1, 1, 1, 2, 5, 2, 0]
# movements = [1, 2, 6, 2, 1, 2, 5, 2 ,0]
if cube_String == "UUUUUUUUURRRRRRRRRFFFFFFFFFDDDDDDDDDLLLLLLLLLBBBBBBBBB":
    movements = [0]

# movements = [2,6,2,1,2,4,2,1,1,0]
print(len(movements))

# ------------------------- TRANSMISSÃO DOS MOVIMENTOS -------------------------
print("Esperando para transmitir movimentos")
data = ser.read(1)
if data == b'\xFF':
    print("Começando transmissao dos movimentos")
    print(movements)
    for movement in movements:
        movement = int(movement)
        ser.write(bytes([movement])) 
        print(f"Movimento transmitido: {movement}")

# ------------------------- LIMPEZA DE IMAGENS -------------------------


# Close the serial port
ser.close()
