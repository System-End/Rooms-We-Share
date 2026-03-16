def current_palette(args)
  member = args.state.current_member || MEMBER_HOST
  PALETTES[member] || PALETTES[MEMBER_HOST]
end

def render_room(args)
  room = args.state.current_room_data
  return unless room

  palette = current_palette(args)
  tiles = room[:parsed_tiles]
  return unless tiles

  args.outputs.solids << {
    x: 0, y: 0, w: SCREEN_W, h: SCREEN_H,
    r: palette[:bg][:r], g: palette[:bg][:g], b: palette[:bg][:b]
  }

  tiles.each_with_index do |row, row_idx|
    row.each_with_index do |tile, col_idx|
      x = col_idx * TILE_SIZE
      y = row_idx * TILE_SIZE

      case tile
      when TILE_WALL
        args.outputs.solids << {
          x: x, y: y, w: TILE_SIZE, h: TILE_SIZE,
          r: palette[:wall][:r], g: palette[:wall][:g], b: palette[:wall][:b]
        }
      when TILE_OBJECT
        args.outputs.solids << {
          x: x + 4, y: y + 4, w: TILE_SIZE - 8, h: TILE_SIZE - 8,
          r: palette[:object][:r], g: palette[:object][:g], b: palette[:object][:b]
        }
      when TILE_MEMORY
        pulse = (Math.sin(Kernel.tick_count * MEMORY_PULSE_SPEED) + 1) / 2
        alpha = (100 + pulse * 155).to_i
        args.outputs.solids << {
          x: x + 8, y: y + 8, w: TILE_SIZE - 16, h: TILE_SIZE - 16,
          r: palette[:accent][:r], g: palette[:accent][:g], b: palette[:accent][:b], a: alpha
        }
      when TILE_DOOR
        args.outputs.solids << {
          x: x + 2, y: y + 2, w: TILE_SIZE - 4, h: TILE_SIZE - 4,
          r: palette[:accent][:r], g: palette[:accent][:g], b: palette[:accent][:b], a: 120
        }
      when TILE_HIDDEN
        # Only visible to certain members
        if [MEMBER_GUARDIAN, MEMBER_ANALYST].include?(args.state.current_member)
          args.outputs.solids << {
            x: x + 4, y: y + 4, w: TILE_SIZE - 8, h: TILE_SIZE - 8,
            r: palette[:accent][:r], g: palette[:accent][:g], b: palette[:accent][:b], a: 80
          }
        end
      end
    end
  end
end

def render_player(args)
  palette = current_palette(args)
  p = args.state.player

  args.outputs.solids << {
    x: p.x, y: p.y, w: p.w, h: p.h,
    r: palette[:player][:r], g: palette[:player][:g], b: palette[:player][:b]
  }
end

def render_overlay(args)
  palette = current_palette(args)
  ov = palette[:overlay]
  return if !ov[:a] || ov[:a] == 0

  args.outputs.solids << {
    x: 0, y: 0, w: SCREEN_W, h: SCREEN_H,
    r: ov[:r], g: ov[:g], b: ov[:b], a: ov[:a]
  }
end

def render_transition(args)
  return unless args.state.transitioning

  elapsed = Kernel.tick_count - args.state.transition_tick
  half = ROOM_TRANSITION_FRAMES / 2

  alpha = if elapsed < half
            (elapsed.to_f / half * 255).to_i
          else
            ((ROOM_TRANSITION_FRAMES - elapsed).to_f / half * 255).to_i
          end

  alpha = alpha.clamp(0, 255)

  args.outputs.solids << {
    x: 0, y: 0, w: SCREEN_W, h: SCREEN_H,
    r: 0, g: 0, b: 0, a: alpha
  }
end
