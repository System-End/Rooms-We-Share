def init_members(args)
  args.state.current_member ||= MEMBER_HOST

  args.state.unlocked_members ||= {
    host: true,
    guardian: false,
    little: false,
    analyst: false
  }

  args.state.member_data ||= {
    host: {
      name: 'You',
      description: 'Everything seems... fine.',
      palette_key: :host
    },
    guardian: {
      name: 'The Guardian',
      description: 'Watch the exits. Check the locks. Stay alert.',
      palette_key: :guardian
    },
    little: {
      name: 'Bailey',
      description: "Ooh! What's that? Can we explore pleaseeee? BOBAAAAA!!",
      palette_key: :little
    },
    analyst: {
      name: 'The Analyst',
      description: 'Cataloguing. Observing. Processing.',
      palette_key: :analyst
    }
  }

  args.state.member_just_switched ||= false
  args.state.member_switch_tick ||= 0
end

def tick_members(args)
  # Reset switch flag each frame
  args.state.member_just_switched = false

  if args.inputs.keyboard.key_down.one
    try_switch_member(args, MEMBER_HOST)
  elsif args.inputs.keyboard.key_down.two
    try_switch_member(args, MEMBER_GUARDIAN)
  elsif args.inputs.keyboard.key_down.three
    try_switch_member(args, MEMBER_LITTLE)
  elsif args.inputs.keyboard.key_down.four
    try_switch_member(args, MEMBER_ANALYST)
  end
end

def try_switch_member(args, member_id)
  # do nothing if not unlocked
  return unless args.state.unlocked_members[member_id]
  # don't switch if already active
  return if args.state.current_member == member_id

  args.state.current_member = member_id

  # set flag so commentary and render know a switch happened
  args.state.member_just_switched = true
  args.state.member_switch_tick = Kernel.tick_count
end
