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
  info: (cb) ->
    @client.get "/users/#{@name}", cb
