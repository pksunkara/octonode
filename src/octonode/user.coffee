#
# user.coffee: Github user class
#
# Copyright © 2011 Pavan Kumar Sunkara. All rights reserved
#

# Requiring modules

# Initiate class
class User

  constructor: (@login, @client) ->

  profile: (data) ->
    Object.keys(data).forEach (e) =>
      @[e] = data[e]

  # Get a user
  # '/users/pkumar' GET
  info: (cb) ->
    @client.get "/users/#{@login}", (err, s, b)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('User info error')) else cb null, b

  # Get the followers of a user
  # '/users/pkumar/followers' GET
  # TODO: page, user
  followers: (cb) ->
    @client.get "/users/#{@login}/followers", (err, s, b)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('User followers error')) else cb null, b

  # Get the followings of a user
  # '/users/pkumar/following' GET
  # TODO: page, user
  following: (cb) ->
    @client.get "/users/#{@login}/following", (err, s, b)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('User following error')) else cb null, b

  # Get events performed by a user
  # '/users/pksunkara/events' GET
  # TODO: page
  events: (events, cb) ->
    if !cb and typeof events == 'function'
      cb = events
      events = null
    else if !Array.isArray events
      events = [events]

    @client.get "/users/#{@login}/events", (err, s, b)  ->
      return cb(err) if err
      return cb(new Error('User events error')) if s isnt 200

      cb null, b.filter (event) ->
        return events.indexOf(event.type) != -1

  # Get a list of organizations a user belongs to and has publicized membership.
  # '/users/pksunkara/orgs' GET
  orgs: (cb) ->
    @client.get "/users/#{@login}/orgs", (err, s, b)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('User organizations error')) else cb null, b

# Export module
module.exports = User
