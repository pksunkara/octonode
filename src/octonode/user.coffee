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
