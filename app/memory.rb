def init_memory(args)
  args.state.memories_collected ||= []
end

def tick_memory(args)
  return if args.state.transitioning

  room = args.state.current_room_data
  return unless room

  tiles = room[:parsed_tiles]
  return unless tiles

  px = args.state.player.x + args.state.player.w / 2
  py = args.state.player.y + args.state.player.h / 2
  player_col = (px / TILE_SIZE).floor
  player_row = (py / TILE_SIZE).floor

  return if player_row < 0 || player_row >= GRID_H
  return if player_col < 0 || player_col >= GRID_W

  return unless tiles[player_row][player_col] == TILE_MEMORY

  memory_key = "#{args.state.current_room}_#{player_col}_#{player_row}"
  return if args.state.memories_collected.include?(memory_key)

  args.state.memories_collected << memory_key
  # Replace tile with empty floor
  tiles[player_row][player_col] = TILE_EMPTY
end

def render_memory(args)
  # Memory pulsing effect is rendered as part of render_room.
  # This is a placeholder for future memory collection UI (flash, text, etc.)
end
