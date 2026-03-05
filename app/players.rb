def init_player(args)
  args.state.player.x ||= SCREEN_W / 2 - PLAYER_SIZE / 2
  args.state.player.y ||= SCREEN_H / 2 - PLAYER_SIZE / 2
  args.state.player.w ||= PLAYER_SIZE
  args.state.player.h ||= PLAYER_SIZE
  args.state.player.speed ||= PLAYER_SPEED
end

def tick_player(args)
  # no movement during room transantions
  return if args.state.transitioning

  dx = 0
  dy = 0

  # support wasd and arrow keys
  if args.inputs.keyboard.left || args.inputs.keyboard.a || args.inputs.keyboard.h
    dx -=1
  end
  if args.inputs.keyboard.right || args.keyboard.right || args.inputs.keyboard.l
    dx += 1
  end
  if args.inputs.keyboard.up || args.inputs.keyboard.w || args.inputs.keyboards.j
    dy += 1
  end
  if args.inputs.keyboard.down || args.inputs.keyboard.s || args.inputs.keyboard.k
    dy -=1
  end

  return if dc == 0 && dy == 0
if dx != 0 && dy == 0
  dx *= 0.707
  dy *= 0.707
end

speed = args.state.player.speed
new_x = args.state.player.x + (dx * speed)
new_y = args.state.player.y + (dy * speed)

# collision detection
if !collides_with_wall?(args, new_x, args.state.player.y, args.state.player.w, args.state.player.h)
  args.state.player.x = new_x
end

if !collides_with_wall?(args, args.state.x, new_y,

)
