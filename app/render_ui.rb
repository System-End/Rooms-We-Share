def render_ui(args)
  palette = current_palette(args)
  member = args.state.current_member || MEMBER_HOST
  member_info = args.state.member_data ? args.state.member_data[member] : nil

  # Current member name (top-left)
  if member_info
    args.outputs.labels << {
      x: 20, y: SCREEN_H - 20,
      text: member_info[:name],
      size_enum: 0,
      r: palette[:accent][:r], g: palette[:accent][:g], b: palette[:accent][:b]
    }
  end

  # Room name (top-center)
  room = ROOMS[args.state.current_room]
  if room
    args.outputs.labels << {
      x: SCREEN_W / 2, y: SCREEN_H - 20,
      text: room[:name],
      size_enum: -1,
      alignment_enum: 1,
      r: palette[:text][:r], g: palette[:text][:g], b: palette[:text][:b], a: 180
    }
  end

  # Memory count (top-right)
  collected = args.state.memories_collected ? args.state.memories_collected.length : 0
  args.outputs.labels << {
    x: SCREEN_W - 20, y: SCREEN_H - 20,
    text: "Memories: #{collected}",
    size_enum: -2,
    alignment_enum: 2,
    r: palette[:text][:r], g: palette[:text][:g], b: palette[:text][:b], a: 150
  }

  # Interaction prompt
  if args.state.nearby_object && !args.state.examining
    args.outputs.labels << {
      x: SCREEN_W / 2, y: 30,
      text: "[E] Examine #{args.state.nearby_object[:name]}",
      size_enum: -1,
      alignment_enum: 1,
      r: palette[:accent][:r], g: palette[:accent][:g], b: palette[:accent][:b]
    }
  end

  # Member switch hints (bottom-left, only show if multiple members unlocked)
  unlocked = args.state.unlocked_members
  if unlocked
    hints = []
    hints << '[1] Host' if unlocked[:host]
    hints << '[2] Guardian' if unlocked[:guardian]
    hints << '[3] Little' if unlocked[:little]
    hints << '[4] Analyst' if unlocked[:analyst]

    if hints.length > 1
      args.outputs.labels << {
        x: 20, y: 30,
        text: hints.join('  '),
        size_enum: -3,
        r: 150, g: 150, b: 150, a: 100
      }
    end
  end

  # Member switch flash effect
  return unless args.state.member_switch_tick

  flash_age = Kernel.tick_count - args.state.member_switch_tick
  return unless flash_age < 15

  flash_alpha = ((15 - flash_age).to_f / 15 * 100).to_i
  flash_alpha = flash_alpha.clamp(0, 100)
  return unless flash_alpha > 0

  args.outputs.solids << {
    x: 0, y: 0, w: SCREEN_W, h: SCREEN_H,
    r: palette[:accent][:r], g: palette[:accent][:g], b: palette[:accent][:b], a: flash_alpha
  }
end
