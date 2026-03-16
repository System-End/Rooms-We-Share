def init_commentary(args)
  args.state.commentary_active ||= false
  args.state.commentary_text ||= ''
  args.state.commentary_tick ||= 0
  args.state.commentary_last_index ||= -1
  args.state.commentary_cooldown ||= 0
end

def tick_commentary(args)
  return if args.state.transitioning
  return if args.state.examining

  # Cooldown between commentary
  if args.state.commentary_cooldown > 0
    args.state.commentary_cooldown -= 1
    return
  end

  # If commentary is active, check if it should end
  if args.state.commentary_active
    elapsed = Kernel.tick_count - args.state.commentary_tick
    total = COMMENTARY_FADE_IN + COMMENTARY_HOLD + COMMENTARY_FADE_OUT
    if elapsed >= total
      args.state.commentary_active = false
      args.state.commentary_cooldown = 120 # 2s cooldown
    end
    return
  end

  # Random chance to trigger new commentary (~1 in 300 frames)
  return unless rand(300) == 0

  room = ROOMS[args.state.current_room]
  return unless room

  member = args.state.current_member || MEMBER_HOST
  lines = room[:commentary][member]
  return unless lines && !lines.empty?

  # Pick a line, avoid repeating the last one
  index = rand(lines.length)
  index = (index + 1) % lines.length if index == args.state.commentary_last_index && lines.length > 1

  args.state.commentary_active = true
  args.state.commentary_text = lines[index]
  args.state.commentary_tick = Kernel.tick_count
  args.state.commentary_last_index = index
end

def render_commentary(args)
  return unless args.state.commentary_active

  elapsed = Kernel.tick_count - args.state.commentary_tick

  # Calculate alpha based on fade phase
  if elapsed < COMMENTARY_FADE_IN
    alpha = (elapsed.to_f / COMMENTARY_FADE_IN * 255).to_i
  elsif elapsed < COMMENTARY_FADE_IN + COMMENTARY_HOLD
    alpha = 255
  else
    fade_elapsed = elapsed - COMMENTARY_FADE_IN - COMMENTARY_HOLD
    alpha = ((1 - fade_elapsed.to_f / COMMENTARY_FADE_OUT) * 255).to_i
  end

  alpha = alpha.clamp(0, 255)
  return if alpha <= 0

  palette = current_palette(args)

  # Float text above the player
  text_x = args.state.player.x + args.state.player.w / 2
  text_y = args.state.player.y + args.state.player.h + 30

  # Keep on screen
  text_x = text_x.clamp(100, SCREEN_W - 100)
  text_y = text_y.clamp(100, SCREEN_H - 20)

  args.outputs.labels << {
    x: text_x, y: text_y,
    text: args.state.commentary_text,
    size_enum: -1,
    alignment_enum: 1,
    r: palette[:text][:r], g: palette[:text][:g], b: palette[:text][:b], a: alpha
  }
end
