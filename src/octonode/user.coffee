#
# user.coffee: Github user class
#
# Copyright © 2011 Pavan Kumar Sunkara. All rights reserved
#

# Requiring modules

# Initiate class
class User

  constructor: (@name, @client) ->

  # Get a user
  # `/users/pkumar`
  info: (cb) ->
    @client.get "/users/#{@name}", (s, b) ->
      if s is 404 then throw new Error 'User not found' else cb b

  # Get the followers of a user
  # '/users/pkumar/followers'
  followers: (cb) ->
    @client.get "/users/#{@name}/followers", (s, b) ->
      if s isnt 200 then throw new Error 'User followers error' else cb b

  # Get the followings of a user
  # '/users/pkumar/following'
  following: (cb) ->
    @client.get "/users/#{@name}/following", (s, b) ->
      if s isnt 200 then throw new Error 'User following error' else cb b
