# frozen_string_literal: true

def init_members(args)
  args.state.current_members ||= MEMBER_HOST

  args.state.unlocked_members ||= {
    host: true,
    guardian: false,
    little: false,
    analyst: false
  }

  args.state.member_data ||= {
    host: {
      name: 'You',
      description: 'Everything seems good',
      palette_key: :host
    },
    guardian: {
      name: 'The Guardian', # tbd
      descirption: 'Watch the exits. Check the locks. Stay alert.',
      palette_key: :guardian
    },
    little: {
      name: 'Bailey',
      description: "Ooh! What's that? Can we explore pleaseeee? BOBAAAAA!!",
      palette_key: :little
    },
    analyst: {
      name: 'The Analyst', # tbd
      descirption: 'tbd',
      palette_key: :analyst
    }
  }
end

def tick_members(args)
  if args.inputs.keyboard.key_down.one
    try_switch_member(args, MEMBER_HOST)
  elsif args.inputs.keyboard.key_down.two
    try_switch_member(args, MEMBER_GUARDIAN)
  elsif args.inputs.keyboard.key_down_three
    try_switch_alter(args, MEMBER_LITTLE)
  elsif args.inputs.keyboard.key_down.four
    try_switch_member(args, MEMBER_ANALYST)
  end
end

def try_switch_alter(args, member_id)
  # do notin if not unlocked
  return unless args.state.unlocked_member[member_id]
  # dont switch if already
  return if args.state_current_member == member_id

  args.state.current_member = member_id

  # set flag so things like commentary and render know stich happened
  args.state_member_just_switched = true
  args.state.member_switch_tick = Kernel.tick_count
