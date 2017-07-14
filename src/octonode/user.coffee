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

  # Get a user (promise)
  info: (cb) ->
    return @client.get("/users/#{@login}", cb)
  # original
  # '/users/pkumar' GET
  # info: (cb) ->
  #   @client.get "/users/#{@login}", (err, s, b, h)  ->
  #     return cb(err) if err
  #     if s isnt 200 then cb(new Error('User info error')) else cb null, b, h

  # Get the followers of a user
  # '/users/pkumar/followers' GET
  # - page or query object, optional - params[0]
  # - per_page, optional             - params[1]

  followers: (params..., cb) ->
    return @client.get "/users/#{@login}/followers", params..., cb

  # original
  # followers: (params..., cb) ->
  #   @client.get "/users/#{@login}/followers", params..., (err, s, b, h)  ->
  #     return cb(err) if err
  #     if s isnt 200 then cb(new Error('User followers error')) else cb null, b, h

  # Get the followings of a user
  # '/users/pkumar/following' GET
  # - page or query object, optional - params[0]
  # - per_page, optional             - params[1]
  following: (params..., cb) ->
    @client.get "/users/#{@login}/following", params..., (err, s, b, h)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('User following error')) else cb null, b, h

  # Get the repos of a user
  # '/users/pkumar/repos' GET
  # - page or query object, optional - params[0]
  # - per_page, optional             - params[1]
  repos: (params..., cb) ->
    @client.get "/users/#{@login}/repos", params..., (err, s, b, h)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('User repos error')) else cb null, b, h

  # Get events performed by a user
  # '/users/pksunkara/events' GET
  # - page or query object, optional - params[0]
  # - per_page, optional             - params[1]
  events: (params..., events, cb) ->
    if !cb and typeof events == 'function'
      cb = events
      events = null
    else if events?
      if typeof events == 'number' and params.length > 0
        params[1] = events
        events = null
      else if !Array.isArray events
        events = [events]

    @client.get "/users/#{@login}/events", params..., (err, s, b, h)  ->
      return cb(err) if err
      return cb(new Error('User events error')) if s isnt 200

      if events?
        b = b.filter (event) ->
          return events.indexOf(event.type) != -1

      cb null, b, h

  # Get a list of organizations a user belongs to and has publicized membership.
  # '/users/pksunkara/orgs' GET
  # - page or query object, optional - params[0]
  # - per_page, optional             - params[1]
  orgs: (params..., cb) ->
    @client.get "/users/#{@login}/orgs", params..., (err, s, b, h)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('User organizations error')) else cb null, b, h

# Export module
module.exports = User
