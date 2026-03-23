# Game constants

SCREEN_W = 1280
SCREEN_H = 720

TILE_SIZE = 40
GRID_W = SCREEN_W / TILE_SIZE  # 32
GRID_H = SCREEN_H / TILE_SIZE  # 18

PLAYER_SIZE = 30
PLAYER_SPEED = 3

# Member identifiers
MEMBER_HOST = :host
MEMBER_GUARDIAN = :guardian
MEMBER_LITTLE   = :little
MEMBER_ANALYST  = :analyst

MEMBER_ORDER = [MEMBER_HOST, MEMBER_GUARDIAN, MEMBER_LITTLE, MEMBER_ANALYST].freeze

# Color palettes per member
PALETTES = {
  host: {
    bg: { r: 180, g: 175, b: 170 },
    wall: { r: 100, g: 95, b: 90 },
    object: { r: 160, g: 155, b: 150 },
    text: { r: 60, g: 55, b: 50 },
    accent: { r: 120, g: 90, b: 60 },
    player: { r: 150, g: 145, b: 140 },
    overlay: { r: 0, g: 0, b: 0, a: 0 }
  },
  guardian: {
    bg: { r: 40,  g: 45,  b: 70 },
    wall: { r: 25, g: 25, b: 45 },
    object: { r: 80, g: 60, b: 60 },
    text: { r: 220, g: 220, b: 240 },
    accent: { r: 255, g: 120,  b: 120 },
    player: { r: 80,  g: 80, b: 160 },
    overlay: { r: 10, g: 10, b: 40, a: 60 }
  },
  little: {
    bg: { r: 255, g: 230, b: 200 },
    wall: { r: 200, g: 170, b: 180 },
    object: { r: 255, g: 200, b: 160 },
    text: { r: 100, g: 60, b: 40 },
    accent: { r: 200, g: 120, b: 40 },
    player: { r: 255, g: 200, b: 180 },
    overlay: { r: 255, g: 230, b: 180, a: 30 }
  },
  analyst: {
    bg: { r: 210, g: 210, b: 210 },
    wall: { r: 50, g: 50, b: 50 },
    object: { r: 180, g: 180, b: 180 },
    text: { r: 40, g: 40, b: 40 },
    accent: { r: 60, g: 140, b: 60 },
    player: { r: 170, g: 170, b: 170 },
    overlay: { r: 0, g: 0, b: 0, a: 20 }
  }
}

# Commentary timing (frames, 60fps)
COMMENTARY_FADE_IN  = 30   # 0.5s appear
COMMENTARY_HOLD     = 180  # 3s visible
COMMENTARY_FADE_OUT = 60   # 1s disappear

# Dialogue
DIALOGUE_TEXT_SPEED = 0.5
DIALOGUE_PADDING    = 20

# Room transitions
ROOM_TRANSITION_FRAMES = 30 # 0.5s fade to black

# Memory
MEMORY_PULSE_SPEED = 0.05

# Tile types
TILE_EMPTY  = 0  # floor
TILE_WALL   = 1
TILE_DOOR   = 2  # triggers room transition
TILE_OBJECT = 3
TILE_MEMORY = 4  # collectible memory fragment
TILE_NPC    = 5
TILE_HIDDEN = 6  # only visible to certain members
