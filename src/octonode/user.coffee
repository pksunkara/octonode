#
# user.coffee: Github user class
#
# Copyright © 2011 Pavan Kumar Sunkara. All rights reserved
#

# Requiring modules

# Initiate class
class User

  constructor: (user, @client) ->
    if typeof user is 'string'
      @login = user
    else
      @profile user

  profile: (data) ->
    @login = data.login

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

# Export module
module.exports = User
