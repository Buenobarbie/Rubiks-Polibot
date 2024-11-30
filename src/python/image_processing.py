import cv2
import numpy as np
import os
def identificar_cor(rgb):
    # Mapear RGB para as cores do cubo
    azul = (8, 20, 72)
    amarelo = (96, 120, 24)
    branco = (96, 116, 120)
    vermelho = (72, 0, 8)
    laranja = (216, 40, 8)  # Aproximação de laranja
    verde = (8, 136, 40)

    cores = {
        "azul": azul,
        "amarelo": amarelo,
        "branco": branco,
        "vermelho": vermelho,
        "laranja": laranja,
        "verde": verde,
    }

    # Encontrar a cor mais próxima
    menor_distancia = float('inf')
    cor_encontrada = None
    for nome, valor in cores.items():
        distancia = np.linalg.norm(np.array(valor) - np.array(rgb))
        if distancia < menor_distancia:
            menor_distancia = distancia
            cor_encontrada = nome

    return cor_encontrada

def matriz_de_cores(imagem):
    # Carregar a imagem
    img = cv2.imread(imagem)  # Read image in BGR format (default)
    img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)  # Convert BGR to RGB

    # Redefinir tamanhos para garantir centralização
    h, w, _ = img.shape
    tamanho_celula = 10  # Tamanho fixo da célula

    # Matriz de cores
    matriz = []

    for i in range(3):  # Linhas
        linha = []
        for j in range(3):  # Colunas
            # Coordenadas do canto superior esquerdo e inferior direito do quadrado
            y1, x1 = 27 + i *(tamanho_celula + 12), 50 + j * (tamanho_celula + 12)
            y2, x2 = y1 + tamanho_celula, x1 + tamanho_celula
            

            # Recorte da célula
            celula = img[y1:y2, x1:x2]

            # Calcular a cor média da célula
            rgb_media = np.mean(celula, axis=(0, 1)).astype(int)
            print(f"Média RGB na célula ({i}, {j}): {rgb_media}")
            cor = identificar_cor(rgb_media)
            linha.append(cor)

            # Desenhar o quadrado ao redor da célula
            cv2.rectangle(img, (x1, y1), (x2, y2), (0, 255, 0), 2)  # Quadrado verde
        matriz.append(linha)

    # Salvar e exibir a imagem processada
    img = cv2.cvtColor(img, cv2.COLOR_RGB2BGR)  # Convert RGB back to BGR for saving
    cv2.imwrite("cubo_processado.png", img)
    cv2.imshow("Cubo com quadrados", img)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

    return matriz

def path_to_most_recent_image(folder_path):
    """Load the most recent image from the folder."""
    files = [f for f in os.listdir(folder_path) if f.lower().endswith(('.png', '.jpg', '.bmp'))]
    files.sort(key=lambda f: os.path.getmtime(os.path.join(folder_path, f)), reverse=True)
    
    if files:
        most_recent_image_path = os.path.join(folder_path, files.pop(0))
        print(f"Loading image: {most_recent_image_path}")
        return most_recent_image_path
    else:
        print("No images found in the folder!")
        return None

def delete_all_images(folder_path):
    """Delete all image files in the folder."""
    for filename in os.listdir(folder_path):
        file_path = os.path.join(folder_path, filename)
        if os.path.isfile(file_path):
            os.remove(file_path)
            # print(f"Deleted image: {filename}")

