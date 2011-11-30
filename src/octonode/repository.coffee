#
# repository.coffee: Github repository class
#
# Copyright © 2011 Pavan Kumar Sunkara. All rights reserved
#

# Requiring modules

# Initiate class
class Repository

  constructor: (@name, @client) ->

  # Get a repository
  info: (cb) ->
    @client.get "/repos/#{@name}", cb
