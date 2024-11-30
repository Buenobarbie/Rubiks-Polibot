import numpy as np
cube = []
face_letters = ['R', 'B', 'L', 'F', 'D', 'U']
face_colors = []
colors_read = [ [ ["vermelho", "laranja", "laranja" ],["vermelho", "amarelo", "amarelo" ], ["azul", "amarelo", "amarelo" ] ],
              [ ["branco", "azul", "branco" ],["laranja", "azul", "branco" ], ["laranja", "azul", "branco" ]],
              [ ["vermelho", "verde", "laranja" ],["vermelho", "branco", "laranja" ], ["vermelho", "branco", "amarelo" ] ],
              [ ["verde", "verde", "amarelo" ],["verde", "verde", "amarelo" ], ["vermelho", "vermelho", "amarelo" ] ],
              [ ["laranja", "verde", "verde" ],["azul", "laranja", "branco" ], ["azul", "laranja", "verde" ] ],
              [ ["azul", "azul", "verde" ] ,["amarelo", "vermelho", "branco" ], ["azul", "vermelho", "branco" ] ] ]
for i in range(1,7):
    # colors = matriz_de_cores(cube_faces[i-1])
    colors = colors_read[i-1]
    # colors = rotated_180 = np.array(colors)[::-1, ::-1].tolist() 
    
    face_colors.append(colors[1][1])

    if i == 5 or i == 6:
        print(colors)
        colors = np.array(colors)[::-1].T.tolist()

        print("Rotated 90")
        print(colors)

    cube.append(colors)
# print("Cube: ", cube)
# print("-------------------")
cube_String = ""
print(cube[face_letters.index('U')])
for i in range(3):
    for j in range(3):

        color = cube[face_letters.index('U')][i][j]
        letter = face_letters[face_colors.index(color)]
        cube_String += letter

print(cube[face_letters.index('R')])
for i in range(3):
    for j in range(3):
        color = cube[face_letters.index('R')][i][j]
        letter = face_letters[face_colors.index(color)]
        cube_String += letter

print(cube[face_letters.index('F')])
for i in range(3):
    for j in range(3):
        color = cube[face_letters.index('F')][i][j]
        letter = face_letters[face_colors.index(color)]
        cube_String += letter

print(cube[face_letters.index('D')])
for i in range(3):
    for j in range(3):
        color = cube[face_letters.index('D')][i][j]
        letter = face_letters[face_colors.index(color)]
        cube_String += letter

print(cube[face_letters.index('L')])
for i in range(3):
    for j in range(3):
        color = cube[face_letters.index('L')][i][j]
        letter = face_letters[face_colors.index(color)]
        cube_String += letter

print(cube[face_letters.index('B')])
for i in range(3):
    for j in range(3):
        color = cube[face_letters.index('B')][i][j]
        letter = face_letters[face_colors.index(color)]
        cube_String += letter
    
print(cube_String)

import kociemba
steps = kociemba.solve(cube_String)
print(steps)
