#
# me.coffee: Github authenticated user class
#
# Copyright © 2011 Pavan Kumar Sunkara. All rights reserved
#

# Requiring modules

# Initiate class
class Me

  constructor: (@client) ->

  # Get a user
  # `/user` (yes)
  info: (cb) ->
    @client.get "/user", (s, b) ->
      if s is 404 then throw new Error 'User not found' else cb b
