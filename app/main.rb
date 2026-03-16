require 'app/constants'
require 'app/rooms'
require 'app/members'
require 'app/player'
require 'app/objects'
require 'app/commentary'
require 'app/memory'
require 'app/render'
require 'app/render_ui'

def tick(args)
  unless args.state.initialized
    init(args)
    args.state.initialized = true
  end

  tick_members(args)
  tick_player(args)
  tick_objects(args)
  tick_commentary(args)
  tick_memory(args)
  tick_room_transition(args)

  render_room(args)
  render_objects(args)
  render_player(args)
  render_commentary(args)
  render_memory(args)
  render_ui(args)
  render_overlay(args)
  render_transition(args)
end

def init(args)
  init_rooms(args)
  init_members(args)
  init_player(args)
  init_objects(args)
  init_commentary(args)
  init_memory(args)
end
