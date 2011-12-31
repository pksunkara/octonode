#
# user.coffee: Github user class
#
# Copyright © 2011 Pavan Kumar Sunkara. All rights reserved
#

# Requiring modules

# Initiate class
class User

  constructor: (user, client) ->
    @client = client
    if typeof user is 'string'
      @login = user
    else
      @profile user

  profile: (data) ->
    @login = data.login

  # Get a user
  # '/users/pkumar' GET
  info: (cb) ->
    @client.get "/users/#{@login}", (s, b) ->
      if s isnt 200 then throw new Error 'User info error' else cb b

  # Get the followers of a user
  # '/users/pkumar/followers' GET
  # TODO: page, user
  followers: (cb) ->
    @client.get "/users/#{@login}/followers", (s, b) ->
      if s isnt 200 then throw new Error 'User followers error' else cb b

  # Get the followings of a user
  # '/users/pkumar/following' GET
  # TODO: page, user
  following: (cb) ->
    @client.get "/users/#{@login}/following", (s, b) ->
      if s isnt 200 then throw new Error 'User following error' else cb b

# Export module
module.exports = User
