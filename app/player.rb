def init_player(args)
  args.state.player.x ||= SCREEN_W / 2 - PLAYER_SIZE / 2
  args.state.player.y ||= SCREEN_H / 2 - PLAYER_SIZE / 2
  args.state.player.w ||= PLAYER_SIZE
  args.state.player.h ||= PLAYER_SIZE
  args.state.player.speed ||= PLAYER_SPEED
end

def tick_player(args)
  # no movement during room transitions
  return if args.state.transitioning

  dx = 0
  dy = 0

  # WASD + arrow keys + HJKL (declan wanted so here it is)
  dx -= 1 if args.inputs.keyboard.left || args.inputs.keyboard.a || args.inputs.keyboard.h
  dx += 1 if args.inputs.keyboard.right || args.inputs.keyboard.d || args.inputs.keyboard.l
  dy += 1 if args.inputs.keyboard.up || args.inputs.keyboard.w || args.inputs.keyboard.k
  dy -= 1 if args.inputs.keyboard.down || args.inputs.keyboard.s || args.inputs.keyboard.j

  return if dx == 0 && dy == 0

  # normalize diagonal movement
  if dx != 0 && dy != 0
    dx *= 0.707
    dy *= 0.707
  end

  speed = args.state.player.speed
  new_x = args.state.player.x + (dx * speed)
  new_y = args.state.player.y + (dy * speed)

  # separate axis collision detection
  unless collides_with_wall?(args, new_x, args.state.player.y, args.state.player.w, args.state.player.h)
    args.state.player.x = new_x
  end

  unless collides_with_wall?(args, args.state.player.x, new_y, args.state.player.w, args.state.player.h)
    args.state.player.y = new_y
  end

  # check for door collision
  check_door_collision(args)
end

def collides_with_wall?(args, x, y, w, h)
  room = args.state.current_room_data
  return false unless room

  tiles = room[:parsed_tiles]
  return false unless tiles

  # check all tiles the player bounding box overlaps
  left_col   = (x / TILE_SIZE).floor
  right_col  = ((x + w - 1) / TILE_SIZE).floor
  bottom_row = (y / TILE_SIZE).floor
  top_row    = ((y + h - 1) / TILE_SIZE).floor

  (bottom_row..top_row).each do |row|
    (left_col..right_col).each do |col|
      next if row < 0 || row >= GRID_H || col < 0 || col >= GRID_W
      return true if tiles[row][col] == TILE_WALL
    end
  end

  false
end

def check_door_collision(args)
  room = args.state.current_room_data
  return unless room

  tiles = room[:parsed_tiles]
  return unless tiles

  px = args.state.player.x
  py = args.state.player.y
  pw = args.state.player.w
  ph = args.state.player.h

  center_col = ((px + pw / 2) / TILE_SIZE).floor
  center_row = ((py + ph / 2) / TILE_SIZE).floor

  return if center_row < 0 || center_row >= GRID_H
  return if center_col < 0 || center_col >= GRID_W

  return unless tiles[center_row][center_col] == TILE_DOOR

  door = find_door_at(args, center_col, center_row)
  return unless door

  start_room_transition(args, door[:target_room], door[:spawn_x], door[:spawn_y])
end
