def init_objects(args)
  args.state.examining ||= false
  args.state.examine_text ||= ''
  args.state.examine_object_id ||= nil
  args.state.nearby_object ||= nil
end

def tick_objects(args)
  return if args.state.transitioning

  # Find nearby interactable object
  args.state.nearby_object = find_nearby_object(args)

  return unless args.inputs.keyboard.key_down.e

  if args.state.examining
    # Close examination
    args.state.examining = false
    args.state.examine_text = ''
    args.state.examine_object_id = nil
  elsif args.state.nearby_object
    # Open examination
    obj = args.state.nearby_object
    member = args.state.current_member || MEMBER_HOST
    text = obj[:examine][member] || obj[:examine][:host] || ''
    args.state.examining = true
    args.state.examine_text = text
    args.state.examine_object_id = obj[:id]
  end
end

def find_nearby_object(args)
  room = ROOMS[args.state.current_room]
  return nil unless room

  px = args.state.player.x + args.state.player.w / 2
  py = args.state.player.y + args.state.player.h / 2
  player_col = (px / TILE_SIZE).floor
  player_row = (py / TILE_SIZE).floor

  room[:objects].each do |obj|
    obj[:cols].each do |col|
      obj[:rows].each do |row|
        tile_row = GRID_H - 1 - row
        dist_col = (player_col - col).abs
        dist_row = (player_row - tile_row).abs
        return obj if dist_col <= 1 && dist_row <= 1
      end
    end
  end

  nil
end

def render_objects(args)
  return unless args.state.examining

  palette = current_palette(args)

  # Examination dialogue box
  box_w = 600
  box_h = 120
  box_x = (SCREEN_W - box_w) / 2
  box_y = 40

  args.outputs.solids << {
    x: box_x, y: box_y, w: box_w, h: box_h,
    r: 20, g: 20, b: 20, a: 220
  }

  args.outputs.borders << {
    x: box_x, y: box_y, w: box_w, h: box_h,
    r: palette[:accent][:r], g: palette[:accent][:g], b: palette[:accent][:b]
  }

  args.outputs.labels << {
    x: box_x + DIALOGUE_PADDING,
    y: box_y + box_h - DIALOGUE_PADDING,
    text: args.state.examine_text,
    size_enum: 0,
    r: palette[:text][:r], g: palette[:text][:g], b: palette[:text][:b]
  }

  # Close prompt
  args.outputs.labels << {
    x: box_x + box_w - 100, y: box_y + 25,
    text: '[E] Close',
    size_enum: -2,
    r: 180, g: 180, b: 180
  }
end
