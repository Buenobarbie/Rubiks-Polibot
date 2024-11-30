import pygame

# Define cube colors
COLORS = {
    'U': (255, 255, 255),  # White
    'R': (255, 0, 0),      # Red
    'L': (255, 165, 0),    # Orange
    'F': (0, 255, 0),      # Green
    'B': (0, 0, 255),      # Blue
    'D': (255, 255, 0),    # Yellow
    'X': (0, 0, 0)         # Black for missing parts
}

# Define positions for cube faces with extra spacing
def get_face_positions():
    spacing = 0  # Space between faces
    face_positions = {
        'U': (270 + spacing,     60),  # Top face
        'L': (100,                220), # Left face
        'F': (270 + spacing,     220), # Front face
        'R': (430 + 2 * spacing, 220), # Right face
        'B': (590 + 3 * spacing, 220), # Back face
        'D': (270 + spacing,     380 + spacing)  # Bottom face
    }
    return face_positions

# Draw a single face on the screen
def draw_face(screen, face, colors, position):
    x_offset, y_offset = position
    square_size = 50
    for i in range(3):
        for j in range(3):
            color = colors[i * 3 + j]
            rect = pygame.Rect(
                x_offset + j * square_size,
                y_offset + i * square_size,
                square_size, square_size
            )
            pygame.draw.rect(screen, color, rect)
            pygame.draw.rect(screen, (0, 0, 0), rect, 2)  # Border

# Main display function
def display_cube(cube_string):
    pygame.init()
    screen = pygame.display.set_mode((850, 600))  # Increased screen size
    pygame.display.set_caption("Rubik's Polibot")

    # Map cube_string to face colors
    face_colors = {
        'U': [COLORS[cube_string[i]] for i in range(9)],
        'L': [COLORS[cube_string[i]] for i in range(9, 18)],
        'F': [COLORS[cube_string[i]] for i in range(18, 27)],
        'R': [COLORS[cube_string[i]] for i in range(27, 36)],
        'B': [COLORS[cube_string[i]] for i in range(36, 45)],
        'D': [COLORS[cube_string[i]] for i in range(45, 54)]
    }

    face_positions = get_face_positions()

    running = True
    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False

        screen.fill((240, 240, 240))  # Light gray background

        # Draw title
        font = pygame.font.Font(None, 48)  # Larger font size
        title_surface = font.render("Rubik's Polibot", True, (50, 50, 50))
        title_rect = title_surface.get_rect(center=(screen.get_width() // 2, 20))
        screen.blit(title_surface, title_rect)

        # Draw all faces
        for face, position in face_positions.items():
            draw_face(screen, face, face_colors[face], position)

        pygame.display.flip()

    pygame.quit()

# Read the cube string from the file
try:
    with open('cube.txt', 'r') as file:
        cube_string = file.read().strip()
        if len(cube_string) != 54:
            raise ValueError("Cube string must be exactly 54 characters long.")
except FileNotFoundError:
    print("Error: cube.txt not found.")
    exit()
except ValueError as e:
    print(f"Error: {e}")
    exit()

# Display the cube
display_cube(cube_string)
