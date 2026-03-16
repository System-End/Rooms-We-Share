# Map characters to tile types
CHAR_TO_TILE = {
  '.' => TILE_EMPTY,
  'W' => TILE_WALL,
  'D' => TILE_DOOR,
  'O' => TILE_OBJECT,
  'M' => TILE_MEMORY,
  'N' => TILE_NPC,
  'H' => TILE_HIDDEN
}


ROOMS = {
  bedroom: {
    name: 'Bedroom',
    layout: [
      'WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW',
      'W..............................W',
      'W..OO..........................W',
      'W..OO..........................W',
      'W..............................W',
      'W..............................W',
      'W..............O...............W',
      'W..............................W',
      'W..............................W',
      'W..............................W',
      'W..............................W',
      'W..............................W',
      'W..............................W',
      'W..............................W',
      'W.........................H....W',
      'W..............................W',
      'W..............................W',
      'WWWWWWWWWWWWWWWDWWWWWWWWWWWWWWWW'
    ],
    doors: [
      { col: 15, row: 17, target_room: :hallway_upstairs,
        spawn_x: 15 * TILE_SIZE, spawn_y: 2 * TILE_SIZE }
    ],
    objects: [
      {
        id: :bed,
        cols: [2, 3], rows: [2, 3],
        name: 'Bed',
        examine: {
          host: "Your bed. It's unmade, as usual.",
          guardian: 'Defensible position. Back to the wall. Good.',
          little: "Ooh, it's so soft! Can we jump on it?",
          analyst: 'Standard twin mattress. Signs of restless sleep patterns.'
        }
      },
      {
        id: :desk,
        cols: [14], rows: [6],
        name: 'Desk',
        examine: {
          host: 'A cluttered desk. Papers, pens, half-finished thoughts.',
          guardian: "...there's a letter here. Don't read it.",
          little: 'Can we draw something? Pleeease?',
          analyst: 'Multiple unfinished documents. Evidence of task-switching behavior.'
        }
      }
    ],
    commentary: {
      host: ['This room feels smaller than it used to.',
             '...when did I last open the curtains?'],
      guardian: ['The window is locked. Good.',
                 'Check under the bed.'],
      little: ['I wanna go explore!',
               'Is someone else here?'],
      analyst: ['Room dimensions: approximately 4x5 meters.',
                'Dust accumulation suggests infrequent cleaning.']
    }
  },

  hallway_upstairs: {
    name: 'Upstairs Hallway',
    layout: [
      'WWWWWWWWWWWWWWWDWWWWWWWWWWWWWWWW',
      'W..............................W',
      'W..............................W',
      'W..............................W',
      'W..............................W',
      'W..............................W',
      'W..............................W',
      'W..............................W',
      'W..............................W',
      'W..............................W',
      'W..............................W',
      'W..............................W',
      'W..............................W',
      'W..............................W',
      'W..............................W',
      'W..............................W',
      'W..............................W',
      'WWWWWWWWWWWWWWWDWWWWWWWWWWWWWWWW'
    ],
    doors: [
      { col: 15, row: 17, target_room: :bedroom,
        spawn_x: 15 * TILE_SIZE, spawn_y: 2 * TILE_SIZE },
      { col: 15, row: 0, target_room: :hallway_main,
        spawn_x: 15 * TILE_SIZE, spawn_y: (GRID_H - 3) * TILE_SIZE }
    ],
    objects: [],
    commentary: {
      host: ['The hallway stretches on.',
             'Family photos line the walls... but the faces seem wrong.'],
      guardian: ['Too many doors. Too many entry points.',
                 'Stay in the middle of the hall.'],
      little: ['This hall is super long! Race you to the end!',
               'The pictures are funny-looking.'],
      analyst: ['Standard residential hallway. Four doors observed.',
                'Photo frames: inconsistent timeline arrangement.']
    }
  }
}

def init_rooms(args)
  args.state.current_room ||= :bedroom
  args.state.transitioning ||= false
  args.state.transition_tick ||= 0
  args.state.transition_target ||= nil
  args.state.transition_spawn_x ||= nil
  args.state.transition_spawn_y ||= nil

  # Parse room layouts into tile arrays
  unless args.state.rooms_parsed
    ROOMS.each do |_room_id, room|
      room[:parsed_tiles] = parse_room_layout(room[:layout])
    end
    args.state.rooms_parsed = true
  end

  args.state.current_room_data = ROOMS[args.state.current_room]
end

def parse_room_layout(layout)
  tiles = []
  layout.reverse.each_with_index do |row_str, row_idx|
    tiles[row_idx] = []
    row_str.chars.each_with_index do |ch, col_idx|
      tiles[row_idx][col_idx] = CHAR_TO_TILE[ch] || TILE_EMPTY
    end
  end
  tiles
end

def find_door_at(args, col, row)
  room = ROOMS[args.state.current_room]
  return nil unless room

  room[:doors].each do |door|
    door_row = GRID_H - 1 - door[:row]
    return door if door[:col] == col && door_row == row
  end

  nil
end

def start_room_transition(args, target_room, spawn_x, spawn_y)
  return if args.state.transitioning
  return unless ROOMS[target_room]

  args.state.transitioning = true
  args.state.transition_tick = Kernel.tick_count
  args.state.transition_target = target_room
  args.state.transition_spawn_x = spawn_x
  args.state.transition_spawn_y = spawn_y
end

def tick_room_transition(args)
  return unless args.state.transitioning

  elapsed = Kernel.tick_count - args.state.transition_tick
  half = ROOM_TRANSITION_FRAMES / 2

  # At the midpoint, switch rooms
  if elapsed == half
    args.state.current_room = args.state.transition_target
    args.state.current_room_data = ROOMS[args.state.current_room]
    args.state.player.x = args.state.transition_spawn_x
    args.state.player.y = args.state.transition_spawn_y
  end

  # End transition
  return unless elapsed >= ROOM_TRANSITION_FRAMES

  args.state.transitioning = false
  args.state.transition_target = nil
end
